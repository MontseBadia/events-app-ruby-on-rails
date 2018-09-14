class Event < ApplicationRecord
  # to_param :slug --> does not work
  
  validates :name, presence: true, uniqueness: true
  validates :location, presence: true
  validates :description, length: {minimum: 25}
  validates :price, numericality: {greater_than_or_equal_to: 0}
  validates :capacity, numericality: {only_integer: true, greater_than: 0}
  validates :image_file_name, allow_blank: true, format: {
    with: /\w+\.(gif|jpg|png)\z/i,
    message: "must reference a GIF, JPG, or PNG image"
  }
  validates :slug, uniqueness: true
  
  has_many :registrations, dependent: :destroy # -> only from the event side
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user #--> likers is our given name
  
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations
  
  before_validation :generate_slug
  
  scope :past, -> { where('starts_at < ?', Time.now).order('starts_at') }
  scope :upcoming, -> { where('starts_at >= ?', Time.now).order('starts_at') } 
  scope :free, -> { upcoming.where(price: 0).order(:name) } 
  scope :recent, ->(max=5) { past.limit(max) }

  
  # def self.past
  #   where('starts_at < ?', Time.now).order('starts_at')
  # end

  # def self.upcoming #does go to db -> self, called via: Event.upcoming
  #   where('starts_at >= ?', Time.now).order('starts_at') #--> query
  # end

  def free? #does not go through db, called via: event1.free?
    # price == 0
    price.blank? || price.zero?
  end

  def spots_left
    capacity - registrations.size
  end

  def sold_out?
    spots_left.zero?
  end

  def to_param #--> overwrites the param -> id
    # "#{id}-#{name.parameterize}"
    slug
  end

  def generate_slug
    self.slug ||= name.parameterize if name #--> without self, it calls to a local variable
  end
end