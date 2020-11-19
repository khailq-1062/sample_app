class Micropost < ApplicationRecord
  MICROPOST_PERMIT = %i(content image).freeze

  belongs_to :user
  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true,
            length: {maximum: Settings.micropost.validate.max_content_length}
  validates :image, content_type: {in: Settings.micropost.type,
                                   message: I18n.t(".valid")},
                    size: {less_than: Settings.max_size_file.megabytes,
                           message: I18n.t(".valid_size_image")}

  scope :feed, ->(user_id){where user_id: user_id if user_id.present?}
  scope :sort_by_date, ->{order created_at: :desc}

  delegate :name, to: :user

  def display_image
    image.variant resize_to_limit: [Settings.image.size, Settings.image.size]
  end
end
