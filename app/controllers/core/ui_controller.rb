class Core::UiController < ApplicationController
  def render_tab
    @tab = Rails.cache.read("tab-#{params[:tab_key]}")
  end
end
