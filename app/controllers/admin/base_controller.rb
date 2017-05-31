class Admin::BaseController < ApplicationController
  before_filter :breadcrumb

  private
  def breadcrumb
    add_breadcrumb 'Administration', admin_settings_path
  end
end