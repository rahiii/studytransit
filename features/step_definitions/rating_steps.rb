Given(/^"([^"]*)" has ratings:$/) do |space_name, table|
  space = Space.find_by!(name: space_name)
  table.hashes.each do |rating_data|
    space.ratings.create!(
      value: rating_data['value'].to_i,
      session_identifier: "test_session_#{SecureRandom.hex(4)}"
    )
  end
end

Then(/^"([^"]*)" should show an average rating$/) do |space_name|
  space = Space.find_by!(name: space_name)
  space_section = page.find(".space-section", text: space_name)
  within(space_section) do
    expect(page).to have_content(/Avg.*\/5/)
  end
end

Then(/^I should see when the rating was last updated$/) do
  expect(page).to have_content("Updated")
  expect(page).to have_content("ago")
end

Then(/^I should see when the capacity was last updated$/) do
  expect(page).to have_content("Updated")
  expect(page).to have_content("ago")
end

Then(/^the timestamp should show the update time$/) do
  expect(page).to have_content(/Updated.*ago/)
end

Then(/^"([^"]*)" should show "([^"]*)"$/) do |space_name, expected_text|
  space = Space.find_by!(name: space_name)
  space_section = page.find(".space-section", text: space_name)
  within(space_section) do
    expect(page).to have_content(expected_text)
  end
end
