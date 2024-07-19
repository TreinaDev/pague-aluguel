class Bill < ApplicationRecord
  has_one :receipt
  validates :issue_date, :due_date, :total_value_cents, :condo_id, :shared_fee_value_cents, :base_fee_value_cents,
            presence: true

  monetize :total_value_cents
  monetize :shared_fee_value_cents
  monetize :base_fee_value_cents

  enum status: { pending: 0, awaiting: 5, paid: 10 }
end
