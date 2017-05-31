class Admin::SettingsController < Admin::BaseController
  menu_item :configurations

  def index
    @page_title = 'Settings'
    edit
    render :action => 'edit'
  end

  def edit
    @page_title = 'Settings'
    add_breadcrumb 'Settings', admin_settings_path
    @options = {}
    @options[:user_format] = Directory::User::USER_FORMATS.keys.collect { |f| [Directory::User.current.name(f), f.to_s] }
  end

  def update
    settings = (params[:settings] || {}).dup.symbolize_keys
    tab = settings.delete :tab
    settings.each do |name, value|
      # remove blank values in array settings
      value.delete_if { |v| v.blank? } if value.is_a?(Array)
      Core::Setting[name] = value
    end
    flash[:notice] = 'Settings updated successfully.'
    redirect_to admin_settings_path(tab)
  end
end