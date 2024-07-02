class Value < ApplicationRecord
  belongs_to :base_fee
  # belongs_to :unit_type

  monetize :price_cents, allow_nil: false, numericality: { greater_than: 0 }
end
