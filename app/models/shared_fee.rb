class SharedFee < ApplicationRecord
  belongs_to :condo
  validates :description, :issue_date, :total_value, :condo_id, presence: true
end
