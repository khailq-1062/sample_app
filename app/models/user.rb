class User < ApplicationRecord
  before_save :downcase_email

  USER_PERMIT = %i(name email password password_confirmation).freeze

  validates :name, presence: true,
    length: {maximum: Settings.user.validate.name_length_max}
  validates :email, presence: true,
    length: {maximum: Settings.user.validate.email_length_max},
    format: {with: Settings.user.validate.valid_regex_email},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.user.validate.pass_length_min}
  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
