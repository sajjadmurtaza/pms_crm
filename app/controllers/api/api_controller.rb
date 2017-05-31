class Api::ApiController < ApplicationController
  skip_before_action :heyday_login, :init_request_data, :verify_authenticity_token
  before_action :authenticate_website

  def authenticate_website
    if request.headers['key'] == 'O37MGhhxLKz69kqmi96YGr25nitvZnms'
      return true
    else
      render json: "Authentication failed"
    end
    puts '#################################'
    puts 'Authenticating Website'
    puts '#################################'
  end
end