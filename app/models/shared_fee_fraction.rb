class SharedFeeFraction < ApplicationRecord
  belongs_to :shared_fee
  belongs_to :unit

  validates :value, presence: true
end
