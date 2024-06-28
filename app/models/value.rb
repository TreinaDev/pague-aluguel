class Value < ApplicationRecord
  belongs_to :base_fee
  belongs_to :unit_type

  validates :unit_type_id, presence: true

  monetize :price_cents,
            allow_nil: false,
            numericality: {
              greater_than: 0
            }

end
