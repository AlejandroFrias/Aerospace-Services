# == Description
# 
# The course entry model holds all relevant data (see schema below) about 
# a course or class.
# 
# == Schema Information
#
# Table name: course_entries
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  course     :string(255)
#  instructor :string(255)
#  reg_limit  :string(255)
#  campus     :string(255)
#  bldg       :string(255)
#  room       :string(255)
#  days       :string(255)
#  start      :string(255)
#  end        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class CourseEntry < ActiveRecord::Base
  # Given a time and building code, finds and returns all the classes occurring 
  # at that time and place. Defaults to searching for current time if not given.
  # 
  # === Parameters
  # * +time+ - a time, that will parsed into standard time of the form YYYY-MM-DD hh:mm:ss -N:NN
  # * +bldg+ - an all caps building code (e.g. SHAN, LAC, etc.)
  # 
  def self.find_at_time_and_building(time, bldg)
    week_days = "SMTWRFS"

    t = Time.parse(time) rescue Time.now
    puts t
    day = week_days[t.wday]
    time_num = t.hour.to_s.rjust(2,"0") + t.min.to_s.rjust(2,"0")

    CourseEntry.where('(days LIKE ?) AND (? BETWEEN start AND end) AND (bldg = ?) ',"%#{day}%", time_num, bldg)
  end
end
