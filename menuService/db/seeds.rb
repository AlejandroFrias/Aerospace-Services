# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


m = Menu.create(school: 'HOCH')
m.meals.create(name: 'pizza!')
m.meals.create(name: 'ice cream :D')

otherMenu = Menu.create(school: 'COLLINS')
otherMenu.meals.create(name: 'pizza!')
otherMenu.meals.create(name: 'ice cream :D')
