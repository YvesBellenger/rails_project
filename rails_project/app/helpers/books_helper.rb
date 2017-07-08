module BooksHelper
  def book_a_la_une(book)

    if book.avatar.exists?
      raw "<div class ='img-une'>
          <a href='/books/#{book.id}'><img src='#{book.avatar.url()}' alt='#{book.title}'/></a>
         </div>"
    else
      raw "<div class ='img-une'>
          <a href='/books/#{book.id}'><h3>#{book.title}</h3></a>
         </div>"

    end
  end

  def create_api_book_helper

  end
end
