class Menu < ActiveRecord::Base
	has_many :meals, dependent: :destroy

	def self.find_menu_at_time_and_building(time, school)
		days = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
		t = Time.parse(time) rescue Time.now
		day = days[t.wday]
		time_num = t.hour.to_s.rjust(2,"0") + t.min.to_s.rjust(2,"0")

        Menu.where('(day = ?) AND (? BETWEEN start AND end) AND (school = ?) ',
        	day, time_num, school).first
    end
end
