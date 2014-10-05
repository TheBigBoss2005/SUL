# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(name: 'Alpha', login_id: 'alpha', email: 'alpha@example.com', password: 'hogehoge')   unless User.find_by(name: 'Alpha')
User.create(name: 'Bravo', login_id: 'bravo', email: 'bravo@example.com', password: 'hogehoge')   unless User.find_by(name: 'Bravo')
User.create(name: 'Charlie', login_id: 'charlie', email: 'chrlie@example.com', password: 'hogehoge') unless User.find_by(name: 'Charlie')
User.create(name: 'Delta', login_id: 'delta', email: 'delta@example.com', password: 'hogehoge')   unless User.find_by(name: 'Delta')
User.create(name: 'Echo', login_id: 'echo', email: 'echo@example.com', password: 'hogehoge')    unless User.find_by(name: 'Echo')
