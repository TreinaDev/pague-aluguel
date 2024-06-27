class Condo < ApplicationRecord
  has_many :unit_types, dependent: :destroy
  has_many :units, through: :unit_types
  has_many :base_fees
end
