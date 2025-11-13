Given("there is a library {string} at {string}") do |library_name, location|
  @library = Library.create!(name: library_name, location: location)
end

Given("the library has the following spaces:") do |table|
  table.hashes.each do |space_data|
    capacity = space_data['capacity'].present? ? space_data['capacity'].to_i : nil
    @library.spaces.create!(
      name: space_data['name'],
      capacity: capacity
    )
  end
end

Given("the library has a space {string} with no capacity") do |space_name|
  @library.spaces.create!(name: space_name, capacity: nil)
end

Given("I am on the library page for {string}") do |library_name|
  library = Library.find_by!(name: library_name)
  visit library_path(library)
end

When("I view the spaces") do
  # This step is already covered by visiting the library page
  # The spaces are displayed automatically on the library show page
end

When("I click the back arrow") do
  click_link(class: "back-arrow")
end

Then("I should be on the libraries index page") do
  expect(current_path).to eq(libraries_path)
end

Then("I should see {string} in the library list") do |library_name|
  expect(page).to have_content(library_name)
end

Then("I should see {string} with capacity {string}") do |space_name, expected_capacity|
  space_section = page.find(".space-section", text: space_name)
  within(space_section) do
    expect(page).to have_content(space_name)
    expect(page).to have_content("Current Capacity: #{expected_capacity}")
  end
end

Then("I should see {int} person icons for {string}") do |expected_count, space_name|
  space_section = page.find(".space-section", text: space_name)
  person_icons = space_section.all(".person-icon")
  expect(person_icons.count).to eq(expected_count)
end

Then("I should not see {string} for {string}") do |text, space_name|
  space_section = page.find(".space-section", text: space_name)
  within(space_section) do
    expect(page).not_to have_content(text)
  end
end
