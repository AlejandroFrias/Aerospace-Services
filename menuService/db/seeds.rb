# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'net/http'
require 'json'
require 'time'


START_END_TIMES = {
	"HOCH" =>
	{
		"sat" =>
		{"brunch" =>
			{"start" => "1030", "end" => "1245"},
		"dinner" =>
		    {"start" => "1700", "end" => "1900"}
		},
	
	"sun" =>
		{"brunch" =>
			{"start" => "1030", "end" => "1245"},
		"dinner" =>
		    {"start" => "1700", "end" => "1900"}
		},
	
	"mon" =>
		{"breakfast" =>
			{"start" => "730", "end" => "930"},
		"lunch" =>
			{"start" => "1115", "end" => "1245"},
		"dinner" =>
			{"start" => "1700", "end" => "1900"}
		},
	
	"tue" =>
		{"breakfast" =>
			{"start" => "730", "end" => "930"},
		"lunch" =>
			{"start" => "1115", "end" => "1245"},
		"dinner" =>
			{"start" => "1700", "end" => "1900"}
		},
	
	"wed" =>
		{"breakfast" =>
			{"start" => "730", "end" => "930"},
		"lunch" =>
			{"start" => "1115", "end" => "1245"},
		"dinner" =>
			{"start" => "1700", "end" => "1900"}
		},
	
	"thu" =>
		{"breakfast" =>
			{"start" => "730", "end" => "930"},
		"lunch" =>
			{"start" => "1115", "end" => "1245"},
		"dinner" =>
			{"start" => "1700", "end" => "1900"}
		},

	"fri" =>
		{"breakfast" =>
			{"start" => "730", "end" => "930"},
		"lunch" =>
			{"start" => "1115", "end" => "1245"},
		"dinner" =>
			{"start" => "1700", "end" => "1900"}
		}
	}
}

SCHOOL_TO_DH_CODE = {
	"mudd" => "HOCH",
	"frary" => "FRAR",
	"frank" => "FRAN",
	"collins" => "COLL",
	"pitzer" => "MCCO",
	"scripps" => "MALL"
}

def set_start_and_end_times(menu)
	# puts menu.attributes
	menu.start = START_END_TIMES[menu.school][menu.day][menu.meal_type]["start"]
	menu.end = START_END_TIMES[menu.school][menu.day][menu.meal_type]["end"]
	menu.save
end

DINING_API_URL = 'http://dining-api.herokuapp.com/all'
response = Net::HTTP.get(URI.parse(DINING_API_URL))
resp_hash = JSON.parse(response)

resp_hash.keys.each do |school|
	resp_hash[school].keys.each do |day|
		resp_hash[school][day].keys.each do |mealtype|
			# Create `Menu` table specifying dining hall, day, + meal type.

			menu = Menu.create(school: SCHOOL_TO_DH_CODE[school], meal_type: mealtype, day: day)

			# TODO -- remove this if clause + populate global hash with all DH times.
			set_start_and_end_times(menu) if school == "mudd"

			# `meals` is an array.
			meals = resp_hash[school][day][mealtype]
			meals.each do |m|
				menu.meals.create(name: m)
			end

		end
	end
end




# routes.each do |r|
# 	menu_resp = Net::HTTP.get(URI.parse(DINING_API_URL+r))
# 	menu_json = JSON.parse(menu_resp)
# 	m = Menu.create(school: )


# result = Net::HTTP.get(URI.parse('http://course-api.herokuapp.com/all'))

# m = Menu.create(school: 'HOCH')
# m.meals.create(name: 'pizza!')
# m.meals.create(name: 'ice cream :D')

# otherMenu = Menu.create(school: 'COLLINS')
# otherMenu.meals.create(name: 'pizza!')
# otherMenu.meals.create(name: 'ice cream :D')
