class User < ActiveRecord::Base
  has_many :submissions
  has_many :diseases, :through => :users

  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates_inclusion_of :admin, in: [true, false]
  has_secure_password

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end


  # related to user statistics
  def num_closed_submissions
    self.submissions.joins(:disease).where('diseases.closed =?', true).count
  end

  def num_correct
    self.submissions.joins(:disease).where('diseases.closed =?', true).where('(submissions.is_related =? and diseases.related > diseases.unrelated) or (submissions.is_related =? and diseases.unrelated > diseases.related)', true, false).count
  end

  def get_accuracy
    # byebug
    return 0.0 if self.num_closed_submissions == 0
    return self.num_correct.to_f / self.num_closed_submissions.to_f
  end

end
