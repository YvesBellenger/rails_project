class UsersController < ApplicationController
  load_and_authorize_resource

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
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
      redirect_to @user, notice: 'User was successfully updated.'
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
