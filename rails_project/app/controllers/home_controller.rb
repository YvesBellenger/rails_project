class HomeController < ApplicationController
  include BooksHelper

  #Afficher les 6 derniers livres ajoutés à la BDD
  def index
    @books = Book.order("created_at desc").first(6)
  end
end