class RentFee < ApplicationRecord
  validates :condo_id, :tenant_id, :owner_id, :unit_id, :value_cents, :issue_date, :fine_cents, :fine_interest,
            presence: true

  monetize :value_cents,
           allow_nil: false,
           numericality: {
             greater_than: 0
           }

  monetize :fine_cents,
           allow_nil: false,
           numericality: {
             greater_than_or_equal_to: 0
           }
end
