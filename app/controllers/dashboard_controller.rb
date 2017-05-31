class DashboardController < ApplicationController
  before_action :check_first_login, only: [:index]

  def index
    add_breadcrumb 'Home'
  end

  def check_first_login
    login_status = current_user.last_login_at

    @first_login = false

    unless login_status
      current_user.last_login_at = Time.now.utc
      current_user.save
      @first_login = true
    end
  end

  def tab_content
    @object = params[:class].constantize.find(params[:id])
  end
end
