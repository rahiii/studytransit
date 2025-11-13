Given(/^I am on the (.+) library page$/) do |library_name|
  library = Library.find_by!(name: library_name)
  visit library_path(library)
end

When(/^I fill in "([^"]*)" for the first space capacity$/) do |value|
  fill_in "space_capacity", with: value, match: :first
end

When(/^I fill in "([^"]*)" for "([^"]*)" capacity$/) do |value, space_name|
  # Find the section containing the space name
  sections = page.all("section.space-section")
  matching_section = sections.find { |section| section.has_content?(space_name) }
  expect(matching_section).not_to be_nil, "Could not find section with space name: #{space_name}"
  within(matching_section) do
    fill_in "space_capacity", with: value
  end
end

When(/^I press "([^"]*)" for the first space$/) do |button_text|
  within("form.capacity-form", match: :first) do
    click_button button_text
  end
end

When(/^I press "([^"]*)" for "([^"]*)"$/) do |button_text, space_name|
  # Find the section containing the space name
  sections = page.all("section.space-section")
  matching_section = sections.find { |section| section.has_content?(space_name) }
  expect(matching_section).not_to be_nil, "Could not find section with space name: #{space_name}"
  within(matching_section) do
    click_button button_text
  end
end

Then(/^I should be on the (.+) library page$/) do |library_name|
  library = Library.find_by!(name: library_name)
  expect(page).to have_current_path(library_path(library))
end

Then(/^the first space should show capacity "([^"]*)"$/) do |expected_capacity|
  within("section.space-section", match: :first) do
    expect(page).to have_content("Current Capacity: #{expected_capacity}")
  end
end

Then(/^"([^"]*)" should show capacity "([^"]*)"$/) do |space_name, expected_capacity|
  # Find the section containing the space name
  sections = page.all("section.space-section")
  matching_section = sections.find { |section| section.has_content?(space_name) }
  expect(matching_section).not_to be_nil, "Could not find section with space name: #{space_name}"
  within(matching_section) do
    expect(page).to have_content("Current Capacity: #{expected_capacity}")
  end
end

Then(/^I should see an error message$/) do
  expect(page).to have_content(/must be between 1 and 5|Capacity must be between 1 and 5/i)
end

Then(/^the error should say "([^"]*)"$/) do |error_message|
  expect(page).to have_content(error_message)
end

Then(/^"([^"]*)" should display (\d+) capacity icons$/) do |space_name, count|
  # Find all sections and look for the one with the matching space name
  sections = page.all("section.space-section")
  matching_section = sections.find { |section| section.has_content?(space_name) }
  expect(matching_section).not_to be_nil, "Could not find section with space name: #{space_name}"
  within(matching_section) do
    icons = page.all(".person-icon")
    expect(icons.count).to eq(count.to_i)
  end
end

When(/^I update "([^"]*)" capacity to "([^"]*)"$/) do |space_name, capacity|
  # Find the section containing the space name
  sections = page.all("section.space-section")
  matching_section = sections.find { |section| section.has_content?(space_name) }
  expect(matching_section).not_to be_nil, "Could not find section with space name: #{space_name}"
  within(matching_section) do
    fill_in "space_capacity", with: capacity
    click_button "Update Capacity"
  end
end

Then(/^"([^"]*)" should show "([^"]*)" for capacity$/) do |space_name, expected_text|
  # Find the section containing the space name
  sections = page.all("section.space-section")
  matching_section = sections.find { |section| section.has_content?(space_name) }
  expect(matching_section).not_to be_nil, "Could not find section with space name: #{space_name}"
  within(matching_section) do
    expect(page).to have_content("Current Capacity: #{expected_text}")
  end
end

Then(/^I should see "([^"]*)"$/) do |message|
  expect(page).to have_content(message)
end

Given(/^"([^"]*)" has no ratings$/) do |space_name|
  space = Space.find_by!(name: space_name)
  space.ratings.destroy_all
end
