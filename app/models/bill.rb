class Bill < ApplicationRecord
  has_one :receipt, dependent: :destroy
  has_many :bill_details, dependent: :destroy
  validates :issue_date, :due_date, :condo_id, presence: true

  monetize :total_value_cents, allow_nil: false, numericality: { greater_than_or_equal_to: 0 }

  monetize :shared_fee_value_cents, numericality: { greater_than_or_equal_to: 0 }

  monetize :base_fee_value_cents, numericality: { greater_than_or_equal_to: 0 }

  monetize :single_charge_value_cents, numericality: { greater_than_or_equal_to: 0 }

  monetize :rent_fee_cents, numericality: { greater_than_or_equal_to: 0 }

  enum status: { pending: 0, awaiting: 5, paid: 10 }
end
