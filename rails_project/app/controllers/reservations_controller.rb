class ReservationsController < ApplicationController
  load_and_authorize_resource

  before_action :set_book, except: :reservations_all
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]



  # GET /reservations/
  # GET /reservations.json
  def index
    @reservations = Reservation.where(:book => @book)
  end

  # GET /reservations
  # GET /reservations.json
  def reservations_all
    @reservations = Reservation.all
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
    if @reservation.rendu
      redirect_to :back, notice: 'Vous ne pouvez pas changer la réservation d\'un livre déjà rendu'
    end
  end

  # POST /reservations
  # POST /reservations.json
  def create
    if stock_book(@book) <= 0
      redirect_to book_reservations_path(@book, @reservation), notice: 'Nous n\'avons plus le livre en stock'
    else
      @reservation_test = Reservation.where(:user_id => current_user.id, :book_id => @book.id, :rendu => false).first
      if !@reservation_test.present?
        @reservation = Reservation.new(reservation_params)
        if (@reservation.date_fin > Date.current )
          Reservation.setup_reservation(@book,@reservation,current_user)
          if @reservation.save
            redirect_to book_reservation_path(@book, @reservation), notice: 'Vous avez bien réservé le livre'
          else
            render :new
          end
        else
          redirect_to new_book_reservation_path(@book), notice: 'Vous ne pouvez pas réserver ce livre pour moins d\'une journée'
        end
      else
        redirect_to book_path(@book), notice: 'Vous avez déjà réservé ce livre'
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
    redirect_to book_reservations_url, notice: 'Reservation was successfully destroyed.'
  end

  def livre_rendu
    set_reservation
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
