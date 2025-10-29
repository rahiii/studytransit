# THIS IS ADDING A Library to a temp database. Its bassed of Background in view_libraries.feature
Given("a library named {string} at {string}") do |name, location|
    Library.create!(name: name, location: location)
  end
  
#this one should simply be filling up the library with spaces
  Given("{string} has spaces:") do |library_name, table|
    library = Library.find_by!(name: library_name)
    table.hashes.each do |row|
      library.spaces.create!(name: row["name"], capacity: row["capacity"].presence&.to_i)
    end
  end
  
  Given("I am on the libraries page") do
    visit libraries_path
  end

  Then("there should be {int} libraries in the database") do |expected|
    expect(Library.count).to eq(expected)
  end
  

  When("I click on {string}") do |text|
    click_link text
  end
  
  Then("I should be on the library page for {string}") do |name|
    library = Library.find_by!(name: name)
    expect(page).to have_current_path(library_path(library))
  end
  
  Then("I should see the room {string}") do |name|
    expect(page).to have_content(name)
  end