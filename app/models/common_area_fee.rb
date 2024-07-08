class CommonAreaFee < ApplicationRecord
  belongs_to :admin

  monetize :value_cents,
           allow_nil: false,
           numericality: {
             greater_than_or_equal_to: 0 # Para aceitar cadastrar uma taxa zero
           }
end
