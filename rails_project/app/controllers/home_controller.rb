class HomeController < ApplicationController
  include BooksHelper

  def index
    response = RestClient.get 'https://www.googleapis.com/books/v1/volumes?q=le seigneur des anneaux'
    @test = JSON.parse(response.body.force_encoding('UTF-8'))
    @books = Book.all
  end
end