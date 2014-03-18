# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
def classes?(b)
  class_rooms = "SHAN, LAC, PA, ON, GA, BK, KE, JA, SP"
  
  !class_rooms[b.code].blank?
end

def dining_hall?(b)
  dining_halls = "HOCH"

  !dining_halls[b.code].blank?
end

def food?(b)
  food = "HOCH, SHAN"

  !food[b.code].blank?
end

def music?(b)
  music = "WEST"

  !music[b.code].blank?
end

def dorm?(b)
  !b.name["Dorm"].blank?
end

building_params = Plist::parse_xml( "db/buildingData.plist" )

building = Tag.create(name: "building")
classes = Tag.create(name: "classes")
dining_hall = Tag.create(name: "dininghall")
food = Tag.create(name: "food")
dorm = Tag.create(name: "dorm")
music = Tag.create(name: "music")


building_params.each do |param|
  b = Building.create(param)
  b.tags.concat(building)
  if classes?(b)
    b.tags.concat(classes)
  end
  if dining_hall?(b)
    b.tags.concat(dining_hall)
  end
  if food?(b)
    b.tags.concat(food)
  end
  if dorm?(b)
    b.tags.concat(dorm)
  end
  if music?(b)
    b.tags.concat(music)
  end
end


