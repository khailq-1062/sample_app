class User < ApplicationRecord
  attr_accessor :remember_token

  before_save :downcase_email

  USER_PERMIT = %i(name email password password_confirmation).freeze

  validates :name, presence: true,
    length: {maximum: Settings.user.validate.name_length_max}
  validates :email, presence: true,
    length: {maximum: Settings.user.validate.email_length_max},
    format: {with: Settings.user.validate.valid_regex_email},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.user.validate.pass_length_min}, allow_nil: true
  has_secure_password

  class << self
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  private

  def downcase_email
    email.downcase!
  end
end
