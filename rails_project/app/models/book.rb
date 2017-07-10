class Book < ApplicationRecord
  resourcify

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

  def self.setup_book(book,item)
    book.title = item["volumeInfo"]["title"]
    book.text = item["volumeInfo"]["description"]
    book.author = item["volumeInfo"]["authors"][0]
    book.date = item["volumeInfo"]["publishedDate"]
    book.google_book_id = item["id"]
    book.stock=0
    if(item["volumeInfo"]["imageLinks"].present?)
      book.remote_url=item["volumeInfo"]["imageLinks"]["thumbnail"]
    else
      book.remote_url= "https://upload.wikimedia.org/wikipedia/commons/6/64/Poster_not_available.jpg"
    end
    book.save
  end

end
