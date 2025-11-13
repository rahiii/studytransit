require 'rails_helper'

RSpec.describe Space, type: :model do
  let(:library) { Library.create!(name: 'Butler Library', location: 'Columbia University') }

  it 'is valid with name, capacity (rating 1-5), and library' do
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
    expect(space.errors[:capacity]).to include("must be between 1 and 5")
  end

  it 'is invalid with capacity above 5' do
    space = library.spaces.build(name: 'Room 209', capacity: 6)
    expect(space).not_to be_valid
    expect(space.errors[:capacity]).to include("must be between 1 and 5")
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

  it 'is valid with capacity of 5' do
    space = library.spaces.build(name: 'Room 209', capacity: 5)
    expect(space).to be_valid
  end

  it 'belongs to library' do
    assoc = described_class.reflect_on_association(:library)
    expect(assoc.macro).to eq :belongs_to
  end

  describe '#last_rating_timestamp' do
    it 'returns the most recent rating timestamp' do
      space = library.spaces.create!(name: 'Test Room')
      rating1 = space.ratings.create!(value: 3, created_at: 2.hours.ago)
      rating2 = space.ratings.create!(value: 4, created_at: 1.hour.ago)

      expect(space.last_rating_timestamp).to eq(rating2.created_at)
    end

    it 'returns nil if no ratings exist' do
      space = library.spaces.create!(name: 'Test Room')
      expect(space.last_rating_timestamp).to be_nil
    end
  end

  describe '#last_rating_timestamp_recent' do
    it 'returns the most recent rating timestamp from the past hour' do
      space = library.spaces.create!(name: 'Test Room')
      old_rating = space.ratings.create!(value: 3, created_at: 2.hours.ago)
      recent_rating = space.ratings.create!(value: 4, created_at: 30.minutes.ago)

      expect(space.last_rating_timestamp_recent).to eq(recent_rating.created_at)
    end

    it 'returns nil if no ratings exist in the past hour' do
      space = library.spaces.create!(name: 'Test Room')
      old_rating = space.ratings.create!(value: 3, created_at: 2.hours.ago)

      expect(space.last_rating_timestamp_recent).to be_nil
    end
  end

  describe '#average_rating_last_hour' do
    it 'returns average of recent ratings when they exist' do
      space = library.spaces.create!(name: 'Test Room')
      space.ratings.create!(value: 3, created_at: 30.minutes.ago)
      space.ratings.create!(value: 5, created_at: 20.minutes.ago)

      expect(space.average_rating_last_hour).to eq(4.0)
    end

    it 'returns nil when no recent ratings and no last week data' do
      space = library.spaces.create!(name: 'Test Room')
      # No ratings at all

      expect(space.average_rating_last_hour).to be_nil
    end

    it 'falls back to last week data when no recent ratings exist' do
      space = library.spaces.create!(name: 'Test Room')
      one_week_ago = 1.week.ago
      # Create ratings from last week (within the 1-hour window)
      space.ratings.create!(value: 4, created_at: one_week_ago - 30.minutes)
      space.ratings.create!(value: 4, created_at: one_week_ago - 10.minutes)

      expect(space.average_rating_last_hour).to eq(4.0)
    end

    context 'with comprehensive rating logic' do
      it 'uses same 1-hour window ending at same time 1 week ago for fallback' do
        space = library.spaces.create!(name: 'Test Room')
        one_week_ago = 1.week.ago

        # Create rating exactly at 1 week ago (should be included)
        space.ratings.create!(value: 5, created_at: one_week_ago)
        # Create rating 30 minutes before 1 week ago (should be included)
        space.ratings.create!(value: 4, created_at: one_week_ago - 30.minutes)
        # Create rating 10 minutes before 1 week ago (should be included)
        space.ratings.create!(value: 4, created_at: one_week_ago - 10.minutes)

        # Should average to 4.33 (rounded to 4.33 or 4.0 depending on precision)
        average = space.average_rating_last_hour
        expect(average).to be_within(0.01).of(4.33)
        expect(space.using_last_week_rating?).to be true
      end

      it 'prioritizes recent ratings over last week data' do
        space = library.spaces.create!(name: 'Test Room')
        one_week_ago = 1.week.ago

        # Create rating from last week (should be ignored if recent ratings exist)
        space.ratings.create!(value: 3, created_at: one_week_ago - 30.minutes)
        # Create recent rating (should be used)
        space.ratings.create!(value: 5, created_at: 30.minutes.ago)

        # Should use recent rating (5.0), not last week rating (3.0)
        expect(space.average_rating_last_hour).to eq(5.0)
        expect(space.using_last_week_rating?).to be false
      end

      it 'excludes ratings outside the 1-hour window for last week fallback' do
        space = library.spaces.create!(name: 'Test Room')
        one_week_ago = 1.week.ago

        # Create rating just outside the window (1 week ago - 1 hour 10 minutes)
        space.ratings.create!(value: 3, created_at: one_week_ago - 1.hour - 10.minutes)
        # Create rating just outside the window (1 week ago + 10 minutes)
        space.ratings.create!(value: 5, created_at: one_week_ago + 10.minutes)
        # Create rating within the window (1 week ago - 30 minutes)
        space.ratings.create!(value: 4, created_at: one_week_ago - 30.minutes)

        # Should only use rating within the window (4.0)
        expect(space.average_rating_last_hour).to eq(4.0)
        expect(space.using_last_week_rating?).to be true
      end

      it 'demonstrates the window: uses same 1-hour window ending at 1 week ago' do
        space = library.spaces.create!(name: 'Test Room')
        one_week_ago = 1.week.ago

        # Create ratings well within the window (not at boundaries to avoid timing issues)
        # Window is: (1 week ago - 1 hour) to (1 week ago)
        # Create rating 30 minutes before 1 week ago
        space.ratings.create!(value: 5, created_at: one_week_ago - 30.minutes)
        # Create rating 45 minutes before 1 week ago
        space.ratings.create!(value: 4, created_at: one_week_ago - 45.minutes)
        # Create rating 15 minutes before 1 week ago
        space.ratings.create!(value: 4, created_at: one_week_ago - 15.minutes)

        # All three should be included (average = (5 + 4 + 4) / 3 = 4.33)
        average = space.average_rating_last_hour
        expect(average).to be_within(0.01).of(4.33)
        expect(space.using_last_week_rating?).to be true

        # Ratings just before the window should be excluded
        space.ratings.create!(value: 2, created_at: one_week_ago - 1.hour - 5.minutes)
        # Should still be 4.33 (the rating outside window is ignored)
        expect(space.average_rating_last_hour).to be_within(0.01).of(4.33)
      end

      it 'returns nil when no ratings exist in past hour or last week window' do
        space = library.spaces.create!(name: 'Test Room')

        # Create ratings outside both windows
        space.ratings.create!(value: 3, created_at: 2.hours.ago) # Too old for recent
        space.ratings.create!(value: 4, created_at: 2.weeks.ago) # Too old for last week

        expect(space.average_rating_last_hour).to be_nil
        expect(space.using_last_week_rating?).to be false
      end
    end
  end

  describe '#average_rating_from_last_week' do
    it 'returns average rating from last week when ratings exist' do
      space = library.spaces.create!(name: 'Test Room')
      one_week_ago = 1.week.ago
      space.ratings.create!(value: 3, created_at: one_week_ago - 30.minutes)
      space.ratings.create!(value: 5, created_at: one_week_ago - 10.minutes)

      expect(space.average_rating_from_last_week).to eq(4.0)
    end

    it 'returns nil when no ratings exist from last week' do
      space = library.spaces.create!(name: 'Test Room')
      # No ratings from last week

      expect(space.average_rating_from_last_week).to be_nil
    end

    it 'returns nil when ratings exist but outside the time window' do
      space = library.spaces.create!(name: 'Test Room')
      # Rating too old (more than 1 week + 1 hour ago)
      space.ratings.create!(value: 4, created_at: 2.weeks.ago)
      # Rating too recent (less than 1 week - 1 hour ago)
      space.ratings.create!(value: 4, created_at: 6.days.ago)

      expect(space.average_rating_from_last_week).to be_nil
    end
  end

  describe '#using_last_week_rating?' do
    it 'returns false when recent ratings exist' do
      space = library.spaces.create!(name: 'Test Room')
      space.ratings.create!(value: 4, created_at: 30.minutes.ago)

      expect(space.using_last_week_rating?).to be false
    end

    it 'returns false when no recent ratings and no last week data' do
      space = library.spaces.create!(name: 'Test Room')
      # No ratings at all

      expect(space.using_last_week_rating?).to be false
    end

    it 'returns true when no recent ratings but last week data exists' do
      space = library.spaces.create!(name: 'Test Room')
      one_week_ago = 1.week.ago
      space.ratings.create!(value: 4, created_at: one_week_ago - 30.minutes)

      expect(space.using_last_week_rating?).to be true
    end
  end

  describe 'callbacks' do
    it 'creates initial rating when space is created with capacity' do
      expect {
        library.spaces.create!(name: 'Test Room', capacity: 3)
      }.to change(Rating, :count).by(1)

      space = library.spaces.last
      expect(space.ratings.last.value).to eq(3)
    end

    it 'does not create initial rating when space is created without capacity' do
      expect {
        library.spaces.create!(name: 'Test Room', capacity: nil)
      }.not_to change(Rating, :count)
    end

    it 'creates rating when capacity is updated' do
      space = library.spaces.create!(name: 'Test Room', capacity: 2)
      space.ratings.destroy_all # Clear initial rating

      expect {
        space.update!(capacity: 4)
      }.to change(Rating, :count).by(1)

      expect(space.ratings.last.value).to eq(4)
    end

    it 'does not create rating when capacity is updated to nil' do
      space = library.spaces.create!(name: 'Test Room', capacity: 2)
      space.ratings.destroy_all # Clear initial rating

      expect {
        space.update!(capacity: nil)
      }.not_to change(Rating, :count)
    end

    it 'does not create rating when capacity is not changed' do
      space = library.spaces.create!(name: 'Test Room', capacity: 3)
      initial_ratings_count = space.ratings.count

      expect {
        space.update!(name: 'Updated Room Name')
      }.not_to change(Rating, :count)
    end

    it 'creates rating when capacity changes from nil to a value' do
      space = library.spaces.create!(name: 'Test Room', capacity: nil)
      space.ratings.destroy_all # Clear any initial rating

      expect {
        space.update!(capacity: 3)
      }.to change(Rating, :count).by(1)

      expect(space.ratings.last.value).to eq(3)
    end

    it 'creates rating when capacity changes from a value to another value' do
      space = library.spaces.create!(name: 'Test Room', capacity: 2)
      space.ratings.destroy_all # Clear initial rating

      expect {
        space.update!(capacity: 5)
      }.to change(Rating, :count).by(1)

      expect(space.ratings.last.value).to eq(5)
    end
  end

  describe '#average_rating_last_hour with empty ratings' do
    it 'handles case when recent_ratings is empty but has empty? method returning false' do
      space = library.spaces.create!(name: 'Test Room')
      # Create an empty relation
      recent_ratings = space.ratings.where("created_at >= ?", 1.hour.ago)
      # This should return nil when empty
      expect(space.average_rating_last_hour).to be_nil
    end
  end
end
