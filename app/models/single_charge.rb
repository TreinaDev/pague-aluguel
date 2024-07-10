class SingleCharge < ApplicationRecord
  validates :unit_id, :issue_date, presence: true

  monetize :value_cents,
           allow_nil: false,
           numericality: {
             greater_than_or_equal_to: 0
           }

  enum charge_type: {
    fine: 0,
    common_area_fee: 2,
    other: 5
  }
end
