class UnitType < ApplicationRecord
  belongs_to :condo
  has_many :units, dependent: :destroy
end
