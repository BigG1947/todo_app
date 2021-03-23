class Priority < ApplicationRecord
  validates :name, :level, presence: true
end
