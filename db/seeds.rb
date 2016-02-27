# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "csv"

buildings_csv = CSV.readlines("db/buildings.csv")
buildings_csv.shift
buildings_csv.each do |row|
  Building.create(building_name: row[1], image_url: row[2], detail: row[3], access: row[4], address: row[5])
end