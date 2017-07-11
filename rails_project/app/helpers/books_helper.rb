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

  def total_et_pretes(book)
    if(book.stock.present?)
      emprunt = Reservation.where(:book_id => book.id, :rendu => false).count(:all)
      if(emprunt > 1)
        raw "/ #{book.stock} (#{emprunt} livres sont actuellement en cours d'emprunt.)"
      else
        raw "/ #{book.stock} (#{emprunt} livre est actuellement en cours d'emprunt.)"
      end
    end
  end

  def en_stock(book)
    if stock_book(book) > 0
      link_to raw('<button>Reserver le livre</button>'), new_book_reservation_path(book)
    else
      raw '<p>Nous n\'avons plus le livre en stock</p>'
    end
  end

  def afficher_date(date)
    begin
      I18n.localize date.to_date, format: :long
    rescue
      date
    end
  end


end
