require 'rails_helper'

RSpec.describe "spaces/edit", type: :view do
  before(:each) do
    @library = Library.create!(name: "Butler Library", location: "Columbia University")
    @space = Space.create!(name: "Main Room", capacity: 3, library: @library)
    assign(:space, @space)
  end


  it "renders the edit space form" do
    render

    assert_select "form[action=?]", space_path(@space) do
      assert_select "input[name=?]", "space[name]"

      assert_select "input[name=?]", "space[capacity]"

      assert_select "input[name=?]", "space[library_id]"
    end
  end
end
