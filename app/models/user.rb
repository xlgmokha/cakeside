class User < ActiveRecord::Base
  validates :name,  :presence => true
  validates :website, :format => URI::regexp(%w(http https)), :allow_blank => true
  validates :city, :presence => true
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :name, :email, :website, :twitter, :facebook, :city, :latitude, :longitude, :password, :password_confirmation, :current_password, :remember_me, :interest_ids
  has_many :creations, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :tutorials, :dependent => :destroy
  has_many :authentications
  has_and_belongs_to_many :interests, :join_table => 'users_interests', :uniq => true, :autosave => true
  has_one :avatar
  acts_as_tagger

  def add_favorite( creation )
    if self.already_likes(creation)
      favorites.find { |favorite| favorite.user == self }
    else
      creation.favorites.create({:user_id => self.id})
    end
  end

  def already_likes(creation)
    Favorite.where("user_id = ? AND creation_id = ?", self.id, creation.id).exists?
  end

  def owns(creation)
    creation.user == self
  end

  def comment_on(creation, comment)
    Comment.create_for(self, creation, comment)
  end

  #def add_creation(params)
    #@creation = creations.create(params)
    #@creation.category_ids = params[:category_ids] ||= []
    #@creation.save!
    #@creation
  #end

  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end
end
