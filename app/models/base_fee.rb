class BaseFee < ApplicationRecord
  belongs_to :condo
  has_many :values
  has_many :unit_type, through: :values

  accepts_nested_attributes_for :values

  enum recurrence: {
    monthly: 0,
    biweekly: 2,
    bimonthly: 4,
    semi_annual: 6,
    yearly: 8
  }

end
