class ReservationsController < ApplicationController
  before_filter :authenticate_user!,only:[:new,:edit,:index]
  before_action :set_book
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]



  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = Reservation.includes(:user,:book)
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    @reservation = Reservation.new
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations
  # POST /reservations.json
  def create
    if @book.stock <= 0
      redirect_to book_reservations_path(@book, @reservation), notice: 'Nous n\'avons plus le livre en stock'
    else
      @reservation = Reservation.new(reservation_params)
      @reservation.user = current_user
      @reservation.book = @book
      @reservation.date_debut = DateTime.now
      @reservation.rendu = false
      @book.stock = @book.stock-1
      @book.save
      if @reservation.save
        redirect_to book_reservation_path(@book, @reservation), notice: 'Vous avez bien réservé le livre'
      else
        render :new
      end
    end
  end

  # PATCH/PUT /reservations/1
  # PATCH/PUT /reservations/1.json
  def update
    set_reservation
    if @reservation.update(reservation_params)
      redirect_to book_reservation_url notice: 'Reservation was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation.destroy
    @book.stock = @book.stock+1
    @book.save
    redirect_to book_reservations_url, notice: 'Reservation was successfully destroyed.'
  end

  def livre_rendu
    set_reservation
    @book.stock = @book.stock+1
    @book.save
    @reservation.rendu = true
    @reservation.save
    redirect_to book_reservation_url, notice: 'Vous avez bien rendu le livre'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def set_book
      @book = Book.find(params[:book_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.require(:reservation).permit(:date_fin,:rendu)
    end



end
