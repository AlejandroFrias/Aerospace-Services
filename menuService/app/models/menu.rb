# == Schema Information
#
# The Menu model provides the data seen below in the schema as well as
# as many meals.
# 
# Table name: menus
#
#  id         :integer          not null, primary key
#  school     :string(255)
#  meal_type  :string(255)
#  day        :string(255)
#  start      :string(255)
#  end        :string(255)
#  created_at :datetime
#  updated_at :datetime
#
class Menu < ActiveRecord::Base
	has_many :meals, dependent: :destroy

    # Finds next upcoming menu from the given time at the given school's dining hall
    # 
    # === Parameters
    # * +time+ - a time that can be parsed by by class Time. If it can't be parsed, it is rescued and uses the current time.
    # * +dining_hall+ - an all caps dining hall building code (e.g. "HOCH")
    # 
	def self.find_menu_at_time_and_building(time, dining_hall)
    	days = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
    	t = Time.parse(time) rescue Time.now
    	day = days[t.wday]
    	time_num = t.hour.to_s.rjust(2,"0") + t.min.to_s.rjust(2,"0")

        # m =  Menu.where('(day = ?) AND (? BETWEEN start AND end) AND (school = ?) ',
        #     	day, time_num, dining_hall).first
        attrs = "id, meal_type, day, start, end"
        menus = Menu.where('(day = ?) AND (school = ?) ', day, dining_hall).order('start DESC').select(attrs)
        result = menus.first
        menus.each do |m|
          result = m unless time_num > m.end
        end

        result
  end
end
