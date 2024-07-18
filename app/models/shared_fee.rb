class SharedFee < ApplicationRecord
  has_many :shared_fee_fractions, dependent: :destroy

  validates :description, :issue_date, :total_value_cents, :condo_id, presence: true
  validate :date_is_future, on: :create

  enum status: {
    active: 0,
    canceled: 5
  }

  monetize :total_value_cents,
           allow_nil: false,
           numericality: {
             greater_than: 0
           }

  def calculate_fractions
    total_fraction = total_fraction_sum(condo_id)
    calculated_cents = UnitType.all(condo_id).flat_map do |unit_type|
      unit_type.unit_ids.map do |unit_id|
        value_cents = ((unit_type.fraction / total_fraction) * total_value_cents).to_i
        shared_fee_fractions.create!(unit_id:, value_cents:)
        value_cents
      end
    end
    adjust_remaining_value_cents(calculated_cents.sum)
  end

  private

  def total_fraction_sum(condo_id)
    unit_types = UnitType.all(condo_id)
    unit_types.sum { |unit_type| unit_type.fraction * unit_type.unit_ids.count }
  end

  def adjust_remaining_value_cents(calculated_total)
    difference = total_value_cents - calculated_total
    return if difference.zero?

    shared_fee_fractions_to_adjust = shared_fee_fractions.to_a.cycle
    adjust_amount = difference.positive? ? 1 : -1

    difference.abs.times do
      adjust_fraction = shared_fee_fractions_to_adjust.next
      adjust_fraction.update(value_cents: adjust_fraction.value_cents + adjust_amount)
    end
  end

  def date_is_future
    return unless issue_date.present? && issue_date < Time.zone.today

    errors.add(:issue_date, 'deve ser a partir de hoje.')
  end
end
