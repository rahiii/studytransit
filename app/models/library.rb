class Library < ApplicationRecord
    has_many :spaces, dependent: :destroy
    validates :name, presence: true
    validates :location, presence: true
end
