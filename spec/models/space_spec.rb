require 'rails_helper'

RSpec.describe Space, type: :model do
  let(:library) { Library.create!(name: 'Butler Library', location: 'Columbia University') }

  it 'is valid with name, occupancy (rating 1–5), and library' do
    space = library.spaces.build(name: 'Main Room', occupancy: 3)
    expect(space).to be_valid
  end

  it 'is invalid without a name' do
    space = library.spaces.build(occupancy: 3)
    expect(space).not_to be_valid
  end

  it 'is invalid with occupancy below 1' do
    space = library.spaces.build(name: 'Room 209', occupancy: 0)
    expect(space).not_to be_valid
  end

  it 'is invalid with occupancy above 5' do
    space = library.spaces.build(name: 'Room 209', occupancy: 6)
    expect(space).not_to be_valid
  end

  it 'belongs to library' do
    assoc = described_class.reflect_on_association(:library)
    expect(assoc.macro).to eq :belongs_to
  end
end
