# Controller for Course Service.
# === Services Provided
# * GET request all classes happening at a desired time and place
# 
class CourseController < ApplicationController
  # A GET request with a time and building parameter responds with
  # a list of all courses occurring then in that building. Defaults to 
  # current time and NONE building code.
  def index
    p = get_params  
    time = p[:time] || Time.now
    bldg = p[:building] || "NONE"
    @courses = CourseEntry.find_at_time_and_building(time, bldg)
  end

  private
    # white list permitted parameters from the scary internet
    def get_params
      params.permit(:time, :building)
    end
end
