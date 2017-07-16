class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :stock_book


  rescue_from CanCan::AccessDenied do |exception|
    if request.env['HTTP_REFERER'].present?
      redirect_to '/',notice: "Vous n'avez pas l'autorisation d'accéder à cette page"
    else
      redirect_to '/',notice: "Vous n'avez pas l'autorisation d'accéder à cette page"
    end
  end

  #Permet de calculer le stock possédé par rapport au nombre de réservations en cours
  def stock_book(book)
    if(book.stock.present?)
      tmp = Reservation.where(:book_id => book.id, :rendu => false).count(:all)
      @stock_book = book.stock - tmp
    else
      "Stock non défini"
    end
  end






end
