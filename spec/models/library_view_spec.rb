require "rails_helper"

RSpec.describe "View libraries and rooms", type: :system do
  before do
    @butler = Library.create!(name: "Butler Library", location: "Columbia University")
    @butler.spaces.create!(name: "Main Reading Room", capacity: 3)
    @butler.spaces.create!(name: "Talking Room", capacity: 1)
    @avery = Library.create!(name: "Avery Library", location: "Columbia University")
    @avery.spaces.create!(name: "Upstairs", capacity: 3)
    @avery.spaces.create!(name: "Downstairs", capacity: 1)
  end

  it "has two libraries in the database (feature: Loading the library page)" do
    expect(Library.count).to eq(2)
  end

  it "navigates to Butler Library page and shows its rooms (feature: Selecting Butler Library)" do
    visit libraries_path
    click_link "Butler Library"
    expect(page).to have_current_path(library_path(@butler))
    expect(page).to have_content("Main Reading Room")
    expect(page).to have_content("Talking Room")
  end
end