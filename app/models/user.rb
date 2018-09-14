class User < ApplicationRecord
  has_many :registrations, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_events, through: :likes, source: :event
  
  has_secure_password # --> adds validation, including confirmation, as well as authentication

  validates :name, presence: true
  validates :email, format: /\A\S+@\S+\z/, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 10, allow_blank: true } #--> last bit deactivates min-length when field is blank
  validates :username, presence: true,
                        format: /\A[A-Z0-9]+\z/i,
                        uniqueness: { case_sensitive: false } 
                        
  scope :by_name, -> { order(:name) }
  scope :not_admins, -> { by_name.where(admin: false) }

  before_save :format_username
  before_validation :generate_slug

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  def self.authenticate(email_or_username, password)
    user = User.find_by(email: email_or_username) || User.find_by(username: email_or_username) #--> no instance variables!! no model
    user && user.authenticate(password) #--> right side will never run if user is nil, returns either nil or user
  end

  def format_username
    self.username = username.downcase #--> why second username without self?
  end

  def to_param
    slug 
  end

  def generate_slug
    self.slug ||= name.parameterize if name #--> without self, it calls to a local variable
  end
end
