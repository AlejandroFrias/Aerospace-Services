require 'time'

# The base controller.
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_format

  # Initializes the API service to only respond with xml
  def set_format
    request.format = 'xml'
  end
end
