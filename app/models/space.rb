class Space < ApplicationRecord
  belongs_to :library
  validates :name, presence: true
  validates :capacity, inclusion: { in: 1..3, message: "must be between 1 and 3" }, allow_nil: true
end
