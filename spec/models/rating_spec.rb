require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:library) { Library.create!(name: "Test Library", location: "Test Location") }
  let(:space) { Space.create!(name: "Test Space", library: library) }

  it 'is valid with a value between 1 and 5' do
    rating = Rating.new(space: space, value: 3)
    expect(rating).to be_valid
  end

  it 'is invalid without a value' do
    rating = Rating.new(space: space, value: nil)
    expect(rating).not_to be_valid
    expect(rating.errors[:value]).to include("can't be blank")
  end

  it 'is invalid with a value less than 1' do
    rating = Rating.new(space: space, value: 0)
    expect(rating).not_to be_valid
    expect(rating.errors[:value]).to include("must be between 1 and 5")
  end

  it 'is invalid with a value greater than 5' do
    rating = Rating.new(space: space, value: 6)
    expect(rating).not_to be_valid
    expect(rating.errors[:value]).to include("must be between 1 and 5")
  end

  it 'is valid with value of 1' do
    rating = Rating.new(space: space, value: 1)
    expect(rating).to be_valid
  end

  it 'is valid with value of 5' do
    rating = Rating.new(space: space, value: 5)
    expect(rating).to be_valid
  end

  it 'belongs to space' do
    assoc = described_class.reflect_on_association(:space)
    expect(assoc.macro).to eq :belongs_to
  end
end
