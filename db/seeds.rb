# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create libraries
butler = Library.find_or_create_by!(name: "Butler") do |lib|
  lib.location = "Columbia University"
end

avery = Library.find_or_create_by!(name: "Avery") do |lib|
  lib.location = "Columbia University"
end

noco = Library.find_or_create_by!(name: "NoCo") do |lib|
  lib.location = "Columbia University"
end

milstein = Library.find_or_create_by!(name: "Milstein") do |lib|
  lib.location = "Columbia University"
end

# Create spaces for Butler
butler_room_209 = butler.spaces.find_or_create_by!(name: "Room 209")
butler_room_209.update(capacity: 3) unless butler_room_209.capacity

butler_cafe = butler.spaces.find_or_create_by!(name: "Butler Cafe")
butler_cafe.update(capacity: 3) unless butler_cafe.capacity

butler_main_room = butler.spaces.find_or_create_by!(name: "Main Room")
butler_main_room.update(capacity: 2) unless butler_main_room.capacity

butler_4th_floor = butler.spaces.find_or_create_by!(name: "4th Floor")
butler_4th_floor.update(capacity: 4) unless butler_4th_floor.capacity

puts "Seeded #{Library.count} libraries and #{Space.count} spaces"
