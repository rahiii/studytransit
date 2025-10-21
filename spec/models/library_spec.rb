require 'rails_helper'

RSpec.describe Library, type: :model do
  it 'is valid with a name and location' do
    library = Library.new(name: 'Butler', location: 'Campus')
    expect(library).to be_valid
  end

  it 'is invalid without a name' do
    library = Library.new(location: 'Campus')
    expect(library).not_to be_valid
  end

  it 'is invalid without a location' do
    library = Library.new(name: 'Butler')
    expect(library).not_to be_valid
  end

  it 'has many spaces' do
    assoc = described_class.reflect_on_association(:spaces)
    expect(assoc.macro).to eq :has_many
  end
end
