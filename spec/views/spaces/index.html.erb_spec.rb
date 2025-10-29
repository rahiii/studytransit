require 'rails_helper'

RSpec.describe "spaces/index", type: :view do
  before(:each) do
    library = Library.create!(name: "Butler Library", location: "Columbia University")
    assign(:spaces, [
      Space.create!(name: "Main Room", capacity: 3, library: library),
      Space.create!(name: "Room 209", capacity: 2, library: library)
    ])
  end


  it "renders a list of spaces" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Capacity".to_s), count: 2
    expect(rendered).to match(/Main Room/)
    expect(rendered).to match(/Room 209/)
    expect(rendered).to match(/<strong>Capacity:<\/strong>\s+3/)
    expect(rendered).to match(/<strong>Capacity:<\/strong>\s+2/)
  end
end
