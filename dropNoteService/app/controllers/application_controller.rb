require 'time'
# The base controller.
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :init

  # Initializes the API service to only respond with xml
  def init
    request.format = 'xml'

    # Useful constants
    @SERVER_IP = "134.173.43.28"
    @EDO_URL = "http://#{@SERVER_IP}:8080/edoWeb/services/invoke/"
  end

end
