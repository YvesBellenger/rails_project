class HomeController < ApplicationController
  include BooksHelper

  def index
    @books = Book.all
  end
end