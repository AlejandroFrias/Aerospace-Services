class MenuController < ApplicationController

  def index
  	@menu = Menu.find_menu_at_time_and_building(params[:time] || Time.now,
  												params[:code] || "HOCH")
  end

end
