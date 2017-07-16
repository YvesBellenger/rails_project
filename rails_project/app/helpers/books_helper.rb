module BooksHelper

  # Même si on ne peut pas ne pas upload d'image avec un livre, ce helper vérifie si oui ou non l'image existe et au cas où affiche l'image de non disponibilité
  def book_image(book)
    if book.avatar.exists?
      link_to raw("<img src='#{book.avatar.url()}' class='img-une'>"), book
    else
      link_to raw("<img src='#{image_url("not_available.jpg")}' class='img-une'>"),book
    end
  end

  # Permet d'afficher le nombre total de livre en stock ainsi que le nombre de livres actuellement réservés
  def total_et_pretes(book)
    if(book.stock.present?)
      emprunt = Reservation.where(:book_id => book.id, :rendu => false).count(:all)
      if(emprunt > 1)
        raw "/ #{book.stock} (#{emprunt} livres sont actuellement en cours d'emprunt.)"
      else if emprunt == 1
        raw "/ #{book.stock} (#{emprunt} livre est actuellement en cours d'emprunt.)"
      end
      end
    end
  end

  # Permet d’afficher le bouton de réservation si le livre est en stock, sinon signale à l’utilisateur que le livre n’est plus disponilbe
  def en_stock(book)
    if book.stock.present? && stock_book(book) > 0
      link_to "Réserver le livre", new_book_reservation_path(book), class: 'btn btn-default'
    else
      raw '<div class="alert alert-info"><p>Nous n\'avons plus le livre en stock</p></div>'
    end
  end

  #Permet sur certains livres de l'api google d'afficher la date dans le bon format ou d'afficher ce que google retourne en cas de mauvais format de date
  def afficher_date(date)
    begin
      I18n.localize date.to_date, format: :long
    rescue
      date
    end
  end


end
