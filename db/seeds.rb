# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(name: 'Alpha')   unless User.find_by(name: 'Alpha')
User.create(name: 'Bravo')   unless User.find_by(name: 'Bravo')
User.create(name: 'Charlie') unless User.find_by(name: 'Charlie')
User.create(name: 'Delta')   unless User.find_by(name: 'Delta')
User.create(name: 'Echo')    unless User.find_by(name: 'Echo')
