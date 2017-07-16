class ReservationsController < ApplicationController
  load_and_authorize_resource

  before_action :set_book, except: [:reservations_all, :reservations_all_rendus]
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]



  # GET /book/1/reservations/
  # GET /reservations.json
  def index
    @reservations = Reservation.where(:book => @book, :rendu => false ).order('date_fin asc').paginate(:page => params[:page], :per_page => 20)
  end

  # GET /reservations
  # GET /reservations.json
  def reservations_all
    @reservations = Reservation.where(:rendu => false).order('date_fin asc').paginate(:page => params[:page], :per_page => 20)
  end

  # GET /reservations/rendus
  # GET /reservations/rendus.json
  def reservations_all_rendus
    @reservations = Reservation.where(:rendu => true).order('updated_at desc').paginate(:page => params[:page], :per_page => 20)
  end

  # GET /book/1/reservations/1
  # GET /book/1/reservations/1.json
  def show
  end

  # GET /book/1/reservations/new
  def new
    if !current_user.present?
      redirect_to '/',notice: "Vous n'avez pas l'autorisation d'accéder à cette page"
    else
      @reservation = Reservation.new
    end

  end

  # GET /book/1/reservations/1/edit
  def edit
    if @reservation.rendu
      redirect_to book_path(@book), notice: 'Vous ne pouvez pas changer la réservation d\'un livre déjà rendu'
    end
  end

  # POST /book/1/reservations
  # POST /book/1/reservations.json
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

  # PATCH/PUT /book/1/reservations/1
  # PATCH/PUT /book/1/reservations/1.json
  def update
    set_reservation
    if !reservation_params[:rendu]
      if reservation_params[:date_fin].to_date > Date.current
        if @reservation.update(reservation_params)
          redirect_to book_reservation_url, notice: 'La réservation a bien été mise à jour.'
        else
          render :edit
        end
      else
        redirect_to edit_book_reservation_path(@book,@reservation), notice: 'Vous ne pouvez pas réserver ce livre pour moins d\'une journée'
      end
    else
      if @reservation.update(reservation_params)
        redirect_to book_reservation_url, notice: 'La réservation a bien été mise à jour.'
      else
        render :edit
      end
    end
  end

  # DELETE /book/1/reservations/1
  # DELETE /book/1/reservations/1.json
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
