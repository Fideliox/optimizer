class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery

#  before_filter :index



  before_filter :authenticate_user
  before_filter :set_locale
  before_filter :set_access_control_headers
  around_filter :set_time_zone
#  before_filter :check_admin
  layout :layout_authenticate


  def set_access_control_headers
    headers['Access-Control-Allow-Origin']      = '*'
    headers['Access-Control-Allow-Methods']     = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age']           = '1728000'
    headers['Access-Control-Allow-Credentials'] = 'true'
  end


  def index
    nil
  end

  def authenticate_user
    if !rbo_user_signed_in?
      redirect_to '/rbo_users/sign_in' if params[:controller] != 'devise/sessions'
    else
      Rails.logger.info params[:controller]
      if params[:controller] == 'application'
        redirect_to current_rbo_user.rbo_role.open_path
      end
    end
  end

  private
  def layout_authenticate
    if !rbo_user_signed_in?
      'login'
    else
      'session'
    end
  end

  def set_locale
    cookies[:locale] = params[:locale] if params[:locale]
    cookies[:locale] = 'es' #eliminar para el cambio de idioma
    I18n.locale = cookies[:locale]
  end

  def set_time_zone
    logger.info request.subdomain
    old_time_zone = Time.zone
    Time.zone = ActiveSupport::TimeZone["America/Santiago"]
    yield
  ensure
    Time.zone = old_time_zone
  end


end
