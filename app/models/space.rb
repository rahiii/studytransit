class Space < ApplicationRecord
  belongs_to :library
  has_many :ratings, dependent: :destroy
  validates :name, presence: true
  validates :capacity, inclusion: { in: 1..5, message: "must be between 1 and 5" }, allow_nil: true
  
  after_create :create_initial_rating, if: -> { capacity.present? }
  after_update :create_rating_if_capacity_changed, if: :saved_change_to_capacity?
  
  def average_rating_last_hour
    one_hour_ago = 1.hour.ago
    recent_ratings = ratings.where("created_at >= ?", one_hour_ago)
    
    return nil if recent_ratings.empty?
    
    recent_ratings.average(:value)&.round(2)
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
