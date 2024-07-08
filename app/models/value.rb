class Value < ApplicationRecord
  belongs_to :base_fee

  monetize :price_cents, allow_nil: false, numericality: { greater_than: 0 }, with_model_currency: :brl
end
