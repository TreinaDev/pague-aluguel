class Bill < ApplicationRecord
  def calculate_fees
    unit = Unit.find(unit_id)
    shared_fees = SharedFeeFraction.where(unit_id:)
    base_fees = Value.where(unit_type_id: unit.unit_type_id)
    total_value = 0
    shared_fees.each do |shared_fee|
      total_value += shared_fee.value_cents
    end
    base_fees.each do |base_fee|
      total_value += base_fee.price_cents
    end
    total_value
  end
end
