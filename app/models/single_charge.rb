class SingleCharge < ApplicationRecord
  monetize :value_cents,
           allow_nil: false,
           numericality: {
             greater_than_or_equal_to: 0
           }

  enum charge_type: {
    common_area_fee: 0,
    fine: 2,
    other: 5
  }
end
