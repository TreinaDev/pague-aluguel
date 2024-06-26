class BaseFee < ApplicationRecord
  has_many :values
  has_many :unit_type, through: :values

  enum recurrence: {
    monthly: 0,
    biweekly: 2,
    bimonthly: 4,
    semi_annual: 6,
    yearly: 8
  }

  # enum recurrence: [:monthly, :biweekly, :bimonthly, :semi_annual, :yearly]
end
