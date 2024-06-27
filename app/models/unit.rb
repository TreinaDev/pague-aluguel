class Unit < ApplicationRecord
  belongs_to :unit_type
  has_many :shared_fee_fractions, dependent: :destroy
end
