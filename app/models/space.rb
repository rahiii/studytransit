class Space < ApplicationRecord
  belongs_to :library
  validates :name, presence: true
  validates :occupancy, inclusion: { in: 1..5, message: "must be between 1 and 5" }
end
