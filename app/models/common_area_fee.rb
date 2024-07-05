class CommonAreaFee < ApplicationRecord
  belongs_to :admin

  monetize :value_cents,
           allow_nil: false,
           numericality: {
             greater_than: 0
           }
end
