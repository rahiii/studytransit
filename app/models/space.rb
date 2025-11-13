class Space < ApplicationRecord
  belongs_to :library
  has_many :ratings, dependent: :destroy
  validates :name, presence: true
  validates :capacity, inclusion: { in: 1..5, message: "must be between 1 and 5" }, allow_nil: true

  after_create :create_initial_rating, if: -> { capacity.present? }
  after_update :create_rating_if_capacity_changed, if: :saved_change_to_capacity?

  # Returns the average rating from the past hour, or falls back to the same time last week
  # if no recent ratings exist. This allows the system to show historical trends when
  # current data is unavailable.
  #
  # Note: This method requires real rating data to function properly. With sufficient
  # historical data (at least one week), it will provide fallback ratings from the
  # previous week's same time period.
  #
  # @return [Float, nil] Average rating (1-5) or nil if no ratings found in past hour or last week
  def average_rating_last_hour
    one_hour_ago = 1.hour.ago
    recent_ratings = ratings.where("created_at >= ?", one_hour_ago)

    return recent_ratings.average(:value)&.round(2) unless recent_ratings.empty?

    # Fallback to last week's data if no recent ratings exist
    # Check for ratings from the same time last week (1 week ago - 1 hour to 1 week ago)
    average_rating_from_last_week
  end

  # Returns the average rating from the same time last week (within a 1-hour window)
  # This is used as a fallback when no recent ratings are available.
  #
  # The method looks for ratings created between (1 week ago - 1 hour) and (1 week ago),
  # which represents the same time period from the previous week.
  #
  # @return [Float, nil] Average rating from last week's same time period, or nil if none found
  def average_rating_from_last_week
    one_week_ago = 1.week.ago
    one_week_ago_minus_hour = one_week_ago - 1.hour

    last_week_ratings = ratings.where(
      "created_at >= ? AND created_at <= ?",
      one_week_ago_minus_hour,
      one_week_ago
    )

    return nil if last_week_ratings.empty?

    last_week_ratings.average(:value)&.round(2)
  end

  # Checks if the current rating is from last week's data (fallback) or from the past hour
  # This is useful for displaying appropriate labels in the UI.
  #
  # @return [Boolean] true if using last week's data, false if using recent data or no data
  # Note: This method will return false until sufficient historical data exists (at least one week)
  def using_last_week_rating?
    one_hour_ago = 1.hour.ago
    recent_ratings_count = ratings.where("created_at >= ?", one_hour_ago).count

    # Only use last week's data if no recent ratings exist
    return false unless recent_ratings_count.zero?

    # Check if last week's data exists
    !average_rating_from_last_week.nil?
  end

  # Returns the most recent rating timestamp for this space
  # This is used to display when the space was last rated
  #
  # @return [DateTime, nil] The most recent rating's created_at timestamp, or nil if no ratings exist
  def last_rating_timestamp
    ratings.order(created_at: :desc).first&.created_at
  end

  # Returns the most recent rating timestamp from the past hour
  # This is used to display when the space was last rated (recent data only)
  #
  # @return [DateTime, nil] The most recent rating's created_at timestamp from past hour, or nil if no recent ratings
  def last_rating_timestamp_recent
    one_hour_ago = 1.hour.ago
    ratings.where("created_at >= ?", one_hour_ago).order(created_at: :desc).first&.created_at
  end

  private

  def create_initial_rating
    ratings.create(value: capacity) if capacity.present?
  end

  def create_rating_if_capacity_changed
    if capacity.present?
      ratings.create(value: capacity)
    end
  end
end
