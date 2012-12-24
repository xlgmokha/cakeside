class Creation < ActiveRecord::Base
  acts_as_commentable
  validates :name,  :presence => true
  attr_accessible :user_id, :story, :name, :category_ids, :is_restricted, :watermark, :image
  belongs_to :user
  has_and_belongs_to_many :categories, :join_table => 'creations_categories', :uniq => true, :autosave => true
  has_many :photos, :dependent => :destroy
  has_many :favorites, :dependent => :destroy

  default_scope order("created_at DESC")

  # to be removed and moved to the DisplayCreationDTO
  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end

  def has_comments
    self.comment_threads.length > 0
  end

  def primary_image
    if photos.any?
      photos.first
    else
      Photo.new
    end
  end

  def published?
    photos.count > 0
  end

  def is_safe_for_children?
    is_restricted == false
  end

  def add_photo(photo)
    photos.create({:image => photo})
  end
end
