# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



building_params =
  [{latitude: 0.10, longitude: 0.320, name: 'Shannahan', code: 'SHAN'},
   {latitude: 1.0, longitude: 1.0, name: 'West', code: 'WEST'},
   {latitude: 2.345, longitude: 2.0, name: 'East', code: 'EAST'},
   {latitude: 3.0, longitude: 3.45, name: 'South', code: 'SOUTH'},
   {latitude: 5.0, longitude: 4.0, name: 'North', code: 'NORTH'},
   {latitude: 4.345, longitude: 5.0, name: 'Platt', code: 'PLATT'},
   {latitude: 5.0, longitude: 5.345, name: 'Linde Activity Center', code: 'LAC'}]
building_params.each do |param|
  Building.create(param);
end