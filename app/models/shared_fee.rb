class SharedFee < ApplicationRecord
  after_create :calculate_fractions

  belongs_to :condo
  has_many :shared_fee_fractions

  validates :description, :issue_date, :total_value, :condo_id, presence: true

  def calculate_fractions
    condo.units.each do |unit|
      value = unit.unit_type.ideal_fraction * total_value
      shared_fee_fractions.create!(unit:, value:)
    end
  end
end
