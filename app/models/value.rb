class Value < ApplicationRecord
  belongs_to :base_fee
  belongs_to :unit_type
end
