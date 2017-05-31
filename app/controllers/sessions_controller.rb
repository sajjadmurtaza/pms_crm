class SessionsController < ApplicationController
  skip_before_action :heyday_login, :only => [:new, :destroy, :create]
  layout 'center_column'
  include Heyday

  def new
    @page_title = 'Login'
  end

  def create
    user_id = require_heyday_login unless params[:username].blank? or params[:password].blank?
    if user_id
      @user = Core::SystemUser.find(user_id)
      successful_authentication(@user)
    else
      invalid_credentials
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'You have been logged out successfully.'
    redirect_to root_url
  end

  def invalid_credentials
    logger.warn "Failed login for '#{params[:username]}' from #{request.remote_ip} at #{Time.now.utc}"
    flash.now[:error] = 'Invalid Username Or Password!!!'

    redirect_to new_session_path, :notice => 'Invalid User name or password.Please try again!'
  end

  def successful_authentication(user)
    logger.info "Successful authentication for '#{user.username}' from #{request.remote_ip} at #{Time.now.utc}"
    start_user_session user
    redirect_to root_path, :notice => 'Successfully Logged in'
  end

end
