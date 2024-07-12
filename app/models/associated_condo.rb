class AssociatedCondo < ApplicationRecord
  belongs_to :admin

  validates :condo_id, presence: true
end
