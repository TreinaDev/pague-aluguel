class Bill < ApplicationRecord
  validates :issue_date, :due_date, :total_value_cents, presence: true
end
