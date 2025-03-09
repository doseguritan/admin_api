class HomeController < ApplicationController
 
  def index
    render json: {message: 'Welcome to Admin API'}
  end

end
