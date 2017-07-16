class BooksController < ApplicationController
  load_and_authorize_resource

  before_action :set_book, only: [:show, :edit, :update, :destroy]
  require 'rest-client'
  require 'json'
  require 'uri'

  # GET /books
  # GET /books.json
    def index
    # Récupération de l'url puis parsing
    url = request.fullpath
    uri = URI.parse(url)

    # Ce booléen permet de vérifier dans la vue si oui ou non un paramètre est présent et d'afficher ou non le bouton "afficher tous les livres"
    @req=false

    #On vérifie si un paramètre est présent. Si oui et que c'est q, alors on cherche la correspondance dans la base de données. Sinon on renvoie tous les livres
    if(uri.query.present?)
      parameters = CGI::parse(uri.query)
      if (parameters['q'][0].present?)
        @books = Book.where("title LIKE (?) OR author LIKE (?)", "%#{parameters['q'][0]}%", "%#{parameters['q'][0]}%").paginate(:page => params[:page], :per_page => 12)
        @req=true
      else
        @books = Book.order('title asc').paginate(:page => params[:page], :per_page => 12)
      end
    else
      @books = Book.order('title asc').paginate(:page => params[:page], :per_page => 12)
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    #Permet de renvoyer les livres du même auteur excepté le livre en actuellement regardé
    @booksAuthor = Book.where("author LIKE (?) ", "%#{@book.author}%").where.not(id: @book).order("RANDOM()").limit(6)
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # GET /searchadd
  def searchadd
    url = request.fullpath
    uri = URI.parse(url)

    #Permet sir le paramètre est présent de parser et effectuer correctement la recherche
    if(uri.query.present?)
      parameters = CGI::parse(uri.query)
      if (parameters['q'][0].present?)
        response = RestClient.get 'https://www.googleapis.com/books/v1/volumes?'+URI.encode_www_form( 'q' => parameters['q'][0])+'&maxResults=40&printType=books'
        @items = JSON.parse(response.body.force_encoding('UTF-8'))
      end
    end
  end

  # GET /searchadd/bookinfos
  def searchaddinfos
    url = request.fullpath
    uri    = URI.parse(url)

    #Permet d'afficher correctement le livre sélectionné en fonction de son ID sur l'api google
    if(uri.query.present?)
      parameters = CGI::parse(uri.query)
      if (parameters['q'][0].present?)
        begin
          response = RestClient.get 'https://www.googleapis.com/books/v1/volumes/'+parameters['q'][0]
          @item = JSON.parse(response.body.force_encoding('UTF-8'))
        rescue
          redirect_to search_path_url, notice: 'L\'ID rentrée est incorrecte '
        end
      end
    end
  end

  # POST /books
  # POST /books.json
  def add_book_api
    url    =request.fullpath
    uri    = URI.parse(url)
    if(uri.query.present?)
      @book = Book.new
      parameters = CGI::parse(uri.query)
      response = RestClient.get 'https://www.googleapis.com/books/v1/volumes/'+parameters['q'][0]
      @item = JSON.parse(response.body.force_encoding('UTF-8'))
      @book_test = Book.where(:google_book_id => @item["id"]).first
      if(!@book_test.present?)
        Book.setup_book(@book,@item)
        if @book.save
          redirect_to edit_book_path(@book), notice: 'Le livre a bien été ajouté. Modifiez si nécessaires les derniers détails.'
        else
          render :new
        end
      else
        redirect_to :back, notice: 'Ce livre est déjà présent dans la base de données.'
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
