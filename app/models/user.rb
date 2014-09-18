require 'bcrypt'

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end

class User < ActiveRecord::Base
  include BCrypt
  before_save :ensure_authentication_token
  after_create :send_welcome_email unless Rails.env.test?

  validates :name,  :presence => true
  validates :email, presence: true, uniqueness: true, email: true
  validates :website, :format => URI::regexp(%w(http https)), :allow_blank => true
  #devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  has_many :creations, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :tutorials, :dependent => :destroy
  has_many :activities, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :user_sessions, dependent: :destroy
  has_and_belongs_to_many :interests, :join_table => 'users_interests', :autosave => true
  has_one :avatar
  acts_as_tagger

  def add_favorite(creation)
    creation.liked_by(self)
  end

  def already_likes(creation)
    creation.is_liked_by(self)
  end

  def owns(creation)
    creation.user == self
  end

  def change_password(password, confirmation=password)
    return false unless password == confirmation
    self.password = password
    self.save
  end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.encrypted_password = @password
  end

  def has_avatar?
    self.avatar && self.avatar.avatar.present?
  end

  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end

  def send_welcome_email
    UserMailer.delay.welcome_email(self)
    Subscription.delay.subscribe(email: email, first_name: name, last_name: '')
  end

  def recent_activities(limit = 20)
    activities.includes(:subject).order(created_at: :desc).limit(limit)
  end

  def comment_on(creation, text, disqus_id)
    creation.comments.create(text: text, user: self, disqus_id: disqus_id)
  end

  def favorite_cakes
    favorites.includes(:creation).map {|f| f.creation }
  end

  def create_cake(name:, category:)
    creations.create(name: name, category_id: category.id)
  end

  def valid_password?(password)
    bcrypt = ::BCrypt::Password.new(encrypted_password)
    password = ::BCrypt::Engine.hash_secret(password, bcrypt.salt)
    secure_compare(password, encrypted_password)
  end

  class << self
    def ordered
      User.order(:creations_count => :desc)
    end

    def search_by(query)
      return self.all if query.blank?
      self.where('name like :query or email like :query', query: "#{query}%")
    end

    def login(username, password)
      user = User.find_by(email: username)
      return false if user.nil?
      if user.valid_password?(password)
        UserSession.create!(user: user)
      else
        false
      end
    end

  end

  private

  # constant-time comparison algorithm to prevent timing attacks
  def secure_compare(a, b)
    return false if a.blank? || b.blank? || a.bytesize != b.bytesize
    l = a.unpack "C#{a.bytesize}"

    res = 0
    b.each_byte { |byte| res |= byte ^ l.shift }
    res == 0
  end

  def ensure_authentication_token
    self.authentication_token = SecureRandom.hex(32) if self.authentication_token.blank?
  end

end
