class UsersController < ApplicationController
  load_and_authorize_resource

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    url    =request.fullpath
    uri    = URI.parse(url)
    @req=false
    @users = User.order('nom asc').paginate(:page => params[:page], :per_page => 20)

    if(uri.query.present?)
      parameters = CGI::parse(uri.query)
      if (parameters['q'][0].present?)
        @users = User.where("prenom LIKE (?) OR nom LIKE (?) OR email LIKE (?)", "%#{parameters['q'][0]}%", "%#{parameters['q'][0]}%", "%#{parameters['q'][0]}%").paginate(:page => params[:page], :per_page => 20)
        @req=true
      end
    end

  end

  # GET /users/1
  # GET /users/1.json
  def show
    @reservations = Reservation.includes(:user,:book)
  end

  # GET /profil
  def profil
    if(current_user.present?)
      @reservations = Reservation.includes(:user,:book)
      @user = current_user
    else
      redirect_to new_user_session_path
    end
  end

  # GET /users/1/edit
  def edit
  end

  def new
    redirect_to new_user_session_path
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    set_user
    if @user.update(user_params)
      if current_user != @user
        redirect_to @user, notice: 'L\'utilisateur a bien été mis à jour.'
      else
        redirect_to profil_path_url, notice: 'Votre profil a bien été mis à jour'
      end

    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:nom, :prenom, :description, :mail, :date_inscription)
    end
end
