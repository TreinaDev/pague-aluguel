class SharedFeeFraction < ApplicationRecord
  belongs_to :shared_fee
  belongs_to :unit

  validates :value, :shared_fee, :unit, presence: true
end
