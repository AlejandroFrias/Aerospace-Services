class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :init

  def init
    # set the format to xml only
    request.format = 'xml'

    # useful constants
    @EDO_URL = "http://134.173.43.11:8080/edoWeb/services/invoke/"
    
    @CLASS_ROOMS = "SHAN, LAC, PA, ON, GA, BK, KE, JA, SP"
    @DINING_HALLS = "HOCH"
    @MUSIC = "WEST"
  end
  

end
