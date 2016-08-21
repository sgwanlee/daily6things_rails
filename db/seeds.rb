# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

4.times do |n|
  Task.create!(name: "#{n}_today_task")
end

2.times do |n|
  t = Task.create(name: "#{n}_yesterday_task")
  t.created_at = 1.day.ago
end