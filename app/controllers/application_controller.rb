class ApplicationController < ActionController::Base
  include Heyday::MenuManager::MenuController
  include Heyday::AuthManager::AuthController
  helper Heyday::MenuManager::MenuHelper
  helper DataList::DataListHelper

  protect_from_forgery with: :exception
  before_action :heyday_login, :init_request_data
  before_action :check_listing_layout, only: :index
  theme :theme_selector

  helper_method :search_params?

  has_widgets do |root|
    root << widget(:notes_list)
    root << widget(:task_lists)
  end

  def reset_session
    @_request.reset_session
  end

  def start_user_session(user)
    reset_session
    session[:user_id] = user.id
    session[:ctime] = Time.now.utc.to_i
    session[:atime] = Time.now.utc.to_i
    #if user.must_change_password?
    #  session[:pwd] = '1'
    #end
  end

  def search_params?
    params[:q].present? && params[:q].first[0] != "s"
  end

  private
  def current_user
    begin
      @current_user ||= Directory::User.find(session[:user_id]) if session[:user_id]
      Core::SystemUser.current = @current_user
    rescue Exception => ex
      redirect_to(logout_path) and return
    end
  end
  helper_method :current_user

  def heyday_login
    redirect_to login_path if session[:user_id].nil?
  end

  def not_authenticated
    redirect_to login_url, :alert => "First log in to view this page."
  end

  def init_request_data
    #add_breadcrumb '<i class="home icon"></i>Home'.html_safe, :root_path
    #cookies[:listing_layout] = params[:listing_layout] if params[:listing_layout]
    cookies[:per_page] = params[:per_page] if params[:per_page]
    params[:per_page] = cookies[:per_page] || 10
    if params[:listing_layout].nil?
      controller = "#{params[:controller].titleize.split('/').join('::')}Controller".delete(' ')
      params[:listing_layout] = controller.constantize.respond_to?(:default_view) ? controller.constantize.default_view : 'list'
    end
    I18n.locale = I18n.default_locale
    Date::DATE_FORMATS[:default] = Core::Setting.date_format
    Time::DATE_FORMATS[:default] = Core::Setting.time_format
    DateTime::DATE_FORMATS[:default] = "#{Core::Setting.date_format} #{Core::Setting.time_format}"
    I18n.backend.store_translations :en, date: {formats: {default: Core::Setting.date_format}}
    I18n.backend.store_translations :en, time: {formats: {default: Core::Setting.time_format}}
  end

  def theme_selector
    if current_user and current_user.theme.present?
      return current_user.theme
    else
      return Core::Setting.ui_theme
    end
  end

  def check_listing_layout
    unless params[:controller] == 'crm/leads'
      if cookies[:listing_layout] == 'categorized'
        cookies[:listing_layout] = 'list'
        params[:listing_layout] = cookies[:listing_layout]
      end
    end
  end

  #def current_user
  #  @current_user ||= Directory::User.find(session[:user_id]) if session[:user_id]
  #end
end
