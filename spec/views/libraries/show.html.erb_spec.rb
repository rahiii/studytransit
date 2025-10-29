require 'rails_helper'

RSpec.describe "libraries/show", type: :view do
  before(:each) do
    assign(:library, Library.create!(
      name: "Name",
      location: "Location"
    ))
  end

  it "renders attributes" do
    render
    expect(rendered).to match(/NAME/)
  end
end
