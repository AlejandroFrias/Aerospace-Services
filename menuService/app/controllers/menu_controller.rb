# Controller for Claremont Dining Hall Menu Service
# === Services Provided
# * GET request for the next upcoming meal at the given dining hall from the given time.
# 
# === TODO List
# * Currently the database/service only support Mudd's dining hall, HOCH. We'd like to add other dining halls in the future
# 
class MenuController < ApplicationController

  # GET request returns a single menu, including all the meals, start and end time, and meal type.
  # === Parameters
  # * +time+ - defaults to current time
  # * +code+ - an all caps building code, defaults to HOCH
  def index
    p = search_params
  	@menu = Menu.find_menu_at_time_and_building(p[:time] || Time.now,
                                                p[:code] || "HOCH")
  end
  private
    # White list permitted search parameters
    def search_params
      params.permit(:time, :code)
    end

end
