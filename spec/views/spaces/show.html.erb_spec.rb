require 'rails_helper'

RSpec.describe "spaces/show", type: :view do
  before(:each) do
    assign(:space, Space.create!(
      name: "Name",
      occupancy: 2,
      library: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
  end
end
