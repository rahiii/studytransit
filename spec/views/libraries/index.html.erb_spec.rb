require 'rails_helper'

RSpec.describe "libraries/index", type: :view do
  before(:each) do
    assign(:libraries, [
      Library.create!(
        name: "Name",
        location: "Location"
      ),
      Library.create!(
        name: "Name",
        location: "Location"
      )
    ])
  end

  it "renders a list of libraries" do
    render
    expect(rendered).to match(/Name/)
  end
end
