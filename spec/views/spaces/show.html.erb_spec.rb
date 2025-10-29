require 'rails_helper'

RSpec.describe "spaces/show", type: :view do
  before(:each) do
    library = Library.create!(name: "Butler Library", location: "Columbia University")
    assign(:space, Space.create!(
      name: "Main Room",
      occupancy: 4,
      library: library
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(//)
  end
end
