# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u1 = User.create(name: "public", password: "password")
# u2 = User.create(name: "me", password: "mine")

t1 = Tag.create(name: "note")
t2 = Tag.create(name: "test")
# t3 = Tag.create(name: "third")

n1 = Note.create(title: "Hello World", body: "This is a test note.", latitude: 34.106083, longitude: -117.711717, altitude: 0)
# n2 = Note.create(title: "Test 2", body: "Another Test Note", latitude: 34.106083, longitude: -117.711717, altitude: 0)
# n3 = Note.create(title: "Third Test", body: "Not the Fourth.", latitude: 34.106083, longitude: -117.711717, altitude: 0)


n1.tags.concat(t1)
# n2.tags.concat(t1)
# n3.tags.concat(t1)

n1.tags.concat(t2)
# n2.tags.concat(t2)
# n3.tags.concat(t2)

# n3.tags.concat(t3)


u1.notes.concat(n1)
# u1.notes.concat(n2)
# u2.notes.concat(n3)

# t = Tag.create(name: "note")
# n = Note.create(title: "Hello World", body: "This is a test note.", latitude: 34.106083, longitude: -117.711717, altitude: 0)

