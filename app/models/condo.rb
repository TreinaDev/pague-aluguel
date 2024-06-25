class Condo < ApplicationRecord
  has_many :unit_types
  has_many :units, through: :unit_types
end
