require 'rails_helper'

RSpec.describe Space, type: :model do
  let(:library) { Library.create!(name: 'Butler Library', location: 'Columbia University') }

  it 'is valid with name, capacity (rating 1–5), and library' do
    space = library.spaces.build(name: 'Main Room', capacity: 3)
    expect(space).to be_valid
  end

  it 'is invalid without a name' do
    space = library.spaces.build(capacity: 3)
    expect(space).not_to be_valid
    expect(space.errors[:name]).to include("can't be blank")
  end

  it 'is invalid with capacity below 1' do
    space = library.spaces.build(name: 'Room 209', capacity: 0)
    expect(space).not_to be_valid
    expect(space.errors[:capacity]).to include("must be between 1 and 3")
  end

  it 'is invalid with capacity above 3' do
    space = library.spaces.build(name: 'Room 209', capacity: 4)
    expect(space).not_to be_valid
    expect(space.errors[:capacity]).to include("must be between 1 and 3")
  end

  it 'is valid with nil capacity' do
    space = library.spaces.build(name: 'Room 209', capacity: nil)
    expect(space).to be_valid
  end

  it 'is valid with capacity of 1' do
    space = library.spaces.build(name: 'Room 209', capacity: 1)
    expect(space).to be_valid
  end

  it 'is valid with capacity of 3' do
    space = library.spaces.build(name: 'Room 209', capacity: 3)
    expect(space).to be_valid
  end

  it 'belongs to library' do
    assoc = described_class.reflect_on_association(:library)
    expect(assoc.macro).to eq :belongs_to
  end
end
