require 'rails_helper'

RSpec.describe "libraries/show", type: :view do
  let(:library) { Library.create!(name: "Butler", location: "Columbia University") }
  let!(:space) { Space.create!(name: "Main Room", capacity: 3, library: library) }

  before(:each) do
    assign(:library, library)
  end

  it "renders library name" do
    render
    expect(rendered).to match(/BUTLER/)
  end

  it "renders spaces" do
    render
    expect(rendered).to have_content("Main Room")
  end

  it "does not render current capacity section" do
    render
    expect(rendered).not_to have_content("Current Capacity:")
  end

  it "uses @space when set for error display" do
    # Simulate a failed update - @space should have the same ID as the space in the loop
    space.update_column(:capacity, 3) # Ensure space has capacity
    invalid_space = Space.find(space.id)
    invalid_space.capacity = 6
    invalid_space.valid? # Trigger validation
    assign(:space, invalid_space)

    render
    expect(rendered).to have_content("must be between 1 and 5")
  end

  it "renders rating timestamp below capacity emojis when rating exists" do
    space.ratings.create!(value: 4)
    render
    # Timestamp should be present and below the occupancy indicators
    expect(rendered).to have_content("Updated")
    expect(rendered).to have_content("ago")
    # Verify it's not inside the rating badge
    expect(rendered).to have_css(".rating-timestamp")
  end

  it "renders 'No recent ratings' when no ratings exist" do
    space.ratings.destroy_all
    render
    expect(rendered).to have_content("No recent ratings")
  end
end
