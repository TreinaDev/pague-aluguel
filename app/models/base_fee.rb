class BaseFee < ApplicationRecord
  has_many :values
  has_many :unit_type, through: :values
end
