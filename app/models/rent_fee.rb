class RentFee < ApplicationRecord
  monetize :value_cents,
           allow_nil: false,
           numericality: {
             greater_than: 0
           }

  monetize :fine_cents,
           allow_nil: false,
           numericality: {
             greater_than: 0
           }
end
