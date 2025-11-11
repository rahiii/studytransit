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
butler.update(location: "Columbia University") if butler.location.blank?

avery = Library.find_or_create_by!(name: "Avery Library") do |lib|
  lib.location = "Columbia University"
end
avery.update(location: "Columbia University") if avery.location.blank?

science_eng = Library.find_or_create_by!(name: "Science & Engineering Library (NoCo)") do |lib|
  lib.location = "Columbia University"
end
science_eng.update(location: "Columbia University") if science_eng.location.blank?

uris = Library.find_or_create_by!(name: "Uris Business Library") do |lib|
  lib.location = "Columbia University"
end
uris.update(location: "Columbia University") if uris.location.blank?

# Create spaces for Butler
butler.spaces.find_or_create_by!(name: "Room 209")
butler.spaces.find_or_create_by!(name: "Butler Cafe")
butler.spaces.find_or_create_by!(name: "Main Room")
butler.spaces.find_or_create_by!(name: "4th Floor")

# Create spaces for Science & Engineering Library (NoCo)
science_eng.spaces.find_or_create_by!(name: "North Glass Study Rooms")
science_eng.spaces.find_or_create_by!(name: "Mezzanine Collaborative Tables")
science_eng.spaces.find_or_create_by!(name: "Main Floor Silent Reading Room")

# Create spaces for Uris Business Library
uris.spaces.find_or_create_by!(name: "Main Floor Group Work Area")
uris.spaces.find_or_create_by!(name: "Upper Level Quiet Carrels")

# Create spaces for Avery Library
avery.spaces.find_or_create_by!(name: "First Floor Reading Room")
avery.spaces.find_or_create_by!(name: "Studio Workstation Area")

puts "Seeded #{Library.count} libraries and #{Space.count} spaces"
