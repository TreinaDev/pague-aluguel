class Value < ApplicationRecord
  belongs_to :base_fee
  belongs_to :unit_type

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :unit_type_id, presence: true
end
