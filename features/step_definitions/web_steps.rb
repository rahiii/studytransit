Given(/^the following libraries exist:$/) do |table|
  table.hashes.each do |row|
    Library.create!(
      name: row['name'],
      location: row['location']
    )
  end
end

Given(/^the following spaces exist:$/) do |table|
  table.hashes.each do |row|
    library_name = row['library']
    library = Library.find_by!(name: library_name)
    
    space_attrs = {
      name: row['name'],
      library: library
    }
    
    # Only add capacity if it's provided
    space_attrs[:capacity] = row['capacity'].to_i if row['capacity'].present?
    
    Space.create!(space_attrs)
  end
end

