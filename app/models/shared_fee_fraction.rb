class SharedFeeFraction < ApplicationRecord
  belongs_to :shared_fee
  belongs_to :unit

  validates :value_cents, presence: true

  monetize :value_cents,
           allow_nil: false,
           numericality: {
             greater_than: 0
           }
end
