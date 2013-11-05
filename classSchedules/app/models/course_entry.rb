class CourseEntry < ActiveRecord::Base
  def self.find_at_time_and_building(time, bldg)
    week_days = "SMTWRFS"
    t = Time.parse(time) rescue Time.now
    day = week_days[t.wday]
    time_num = t.hour.to_s.rjust(2,"0") + t.min.to_s.rjust(2,"0")

    CourseEntry.where('(days LIKE ?) AND (? BETWEEN start AND end) AND (bldg = ?) ',"%#{day}%", time_num, bldg)
  end
end
