require 'rails_helper'

RSpec.describe "spaces/edit", type: :view do
  before(:each) do
    library = Library.create!(name: "Butler Library", location: "Columbia University")
    space = Space.create!(name: "Main Room", occupancy: 4, library: library)
    space.reload  # ensure it has an ID
    assign(:space, space)
  end


  it "renders the edit space form" do
    render

    assert_select "form[action=?][method=?]", space_path(assigns(:space)), "post" do
      assert_select "input[name=?]", "space[name]"

      assert_select "input[name=?]", "space[occupancy]"

      assert_select "input[name=?]", "space[library_id]"
    end
  end
end
