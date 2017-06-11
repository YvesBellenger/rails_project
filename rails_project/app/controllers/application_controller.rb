class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #before_filter :configure_permitted_parameters, if: :devise_controller?

  before_action :configure_devise_parameters, if: :devise_controller?

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:email, :password, :password_confirmation)}
  end

  #rescue_from CanCan::AccessDenied do |exception|
  #  flash[:error] = exception.message
  #  if request.env['HTTP_REFERER'].present?
  #    redirect_to :back
  #  else
  #    redirect_to root_url
  #  end
  #end

   #rescue_from CanCan::AccessDenied do |exception|
  #    redirect_to main_app.root_url, notice: exception.message
  #end

end
