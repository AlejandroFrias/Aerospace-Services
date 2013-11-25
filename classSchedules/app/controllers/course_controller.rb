class CourseController < ApplicationController
  def index
    @courses = CourseEntry.find_at_time_and_building(params[:time] || Time.now,
                                                     params[:building] || "NONE")
  end
end
