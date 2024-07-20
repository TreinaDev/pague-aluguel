class BillDetail < ApplicationRecord
  belongs_to :bill

  enum fee_type: {
    shared_fee: 0,
    base_fee: 1,
    fine: 2,
    other: 3,
    common_area_fee: 4
  }

  monetize :value_cents, allow_nil: false, numericality: { greater_than_or_equal_to: 0 }
end
