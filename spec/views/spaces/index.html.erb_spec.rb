require 'rails_helper'

RSpec.describe "spaces/index", type: :view do
  before(:each) do
    library = Library.create!(name: "Butler Library", location: "Columbia University")
    assign(:spaces, [
      Space.create!(name: "Main Room", occupancy: 4, library: library),
      Space.create!(name: "Room 209", occupancy: 2, library: library)
    ])
  end


  it "renders a list of spaces" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s)
  end
end
