class Rating < ApplicationRecord
  belongs_to :space
  validates :value, inclusion: { in: 1..5, message: "must be between 1 and 5" }, presence: true
end
