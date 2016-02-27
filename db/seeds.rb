# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "csv"

users_csv = CSV.readlines("db/users.csv")
users_csv.shift
users_csv.each do |row|
  User.create(email: row[1], encrypted_password: row[2], nickname: row[13])
end