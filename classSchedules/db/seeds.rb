# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'net/http'
require 'rubygems'
require 'json'
require 'time'

result = Net::HTTP.get(URI.parse('http://course-api.herokuapp.com/all'))

parsed = JSON.parse(result)

classes = []
parsed.each do |dept|
  classes += dept.values[0]
end

classes.each do |c|
  c.delete("status")
  c.delete("hours")
  c.delete("section")
  c["end"] = Time.parse(c["end"]).hour.to_s + Time.parse(c["end"]).min.to_s.rjust(2,"0") rescue c["end"]
  c["start"] = Time.parse(c["start"]).hour.to_s + Time.parse(c["start"]).min.to_s.rjust(2,"0") rescue c["start"]
  CourseEntry.create(c)
end
