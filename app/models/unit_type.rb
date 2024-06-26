class UnitType < ApplicationRecord
  belongs_to :condo
  has_many :units
  has_many :values
  has_many :base_fees, through: :values
end
