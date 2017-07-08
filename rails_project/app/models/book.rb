class Book < ApplicationRecord

  has_attached_file :avatar, styles: {
      medium: '300x300>',
      thumb: '100x100>',
  }

  validates_attachment_content_type :avatar,
                                    :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  validates_with AttachmentSizeValidator,
                 attributes: :avatar,
                 less_than: 3.megabytes

  validates :avatar, presence: true



  def remote_url=(url)
    tmp = URI.parse(url)
    self.avatar = tmp
  end

end
