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
    units = Unit.find_all_by_condo(condo_id)
    unit_types = UnitType.find_all_by_condo(condo_id)

    units.each do |unit|
      value_cents = unit_types.find { |ut| ut.id == unit.unit_type_id }.ideal_fraction * total_value_cents
      shared_fee_fractions.create!(unit_id: unit.id, value_cents:)
    end
  end

  private

  def date_is_future
    return unless issue_date.present? && issue_date < Time.zone.today

    errors.add(:issue_date, 'deve ser a partir de hoje.')
  end
end
