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
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Location".to_s), count: 2
  end
end
