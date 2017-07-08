class BooksController < ApplicationController

  before_filter :authenticate_user!,only:[:new,:edit,:create,:searchaddinfos,:searchadd,:add_book_api,:destroy,:update] do
    redirect_to new_user_session_path unless current_user && current_user.admin?
  end

  before_action :set_book, only: [:show, :edit, :update, :destroy]
  require 'rest-client'
  require 'json'
  require 'uri'

  # GET /books
  # GET /books.json
  def index
    :authenticate_user!
    @books = Book.all
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # GET /book/searchadd
  def searchadd
    url    =request.fullpath
    uri    = URI.parse(url)

    if(uri.query.present?)
      params = CGI::parse(uri.query)
      response = RestClient.get 'https://www.googleapis.com/books/v1/volumes?q='+params['q'][0]+'&maxResults=40&printType=books'
      @items = JSON.parse(response.body.force_encoding('UTF-8'))
    end
  end

  # GET /searchadd/bookinfo
  def searchaddinfos

    url    =request.fullpath
    uri    = URI.parse(url)

    if(uri.query.present?)
      params = CGI::parse(uri.query)
      response = RestClient.get 'https://www.googleapis.com/books/v1/volumes/'+params['q'][0]
      @item = JSON.parse(response.body.force_encoding('UTF-8'))
    end
  end

  # POST /books
  # POST /books.json
  def add_book_api
    url    =request.fullpath
    uri    = URI.parse(url)
    if(uri.query.present?)
      @book = Book.new
      params = CGI::parse(uri.query)
      response = RestClient.get 'https://www.googleapis.com/books/v1/volumes/'+params['id'][0]
      @item = JSON.parse(response.body.force_encoding('UTF-8'))
      @book.title = @item["volumeInfo"]["title"]
      @book.text = @item["volumeInfo"]["description"]
      @book.author = @item["volumeInfo"]["authors"][0]
      @book.date = @item["volumeInfo"]["publishedDate"]
      if(@item["volumeInfo"]["imageLinks"].present?)
        @book.remote_url=@item["volumeInfo"]["imageLinks"]["thumbnail"]
      else
        @book.remote_url= "https://upload.wikimedia.org/wikipedia/commons/6/64/Poster_not_available.jpg"
      end
      @book.stock = 0
      @book.save
      if @book.save
        redirect_to edit_book_path(@book), notice: 'Le livre a bien été ajouté. Modifiez si nécessaires les derniers détails.'
      else
        render :new
      end
    end
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book, notice: 'Le livre a bien été crée'
    else
      render :new
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    set_book
    if @book.update(book_params)
      redirect_to @book, notice: 'Le livre a bien été mis à jour'
    else
      render :edit
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    redirect_to books_url, notice: 'Le livre a bien été supprimé.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :text, :author, :date, :stock, :avatar)
    end
end
