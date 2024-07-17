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
    unit_types = UnitType.all(condo_id)
    unit_types.each do |unit_type|
      unit_ids = unit_type.unit_ids
      unit_ids.each do |unit_id|
        value_cents = unit_type.fraction * total_value_cents
        shared_fee_fractions.create!(unit_id:, value_cents:)
      end
    end
  end

  private

  def date_is_future
    return unless issue_date.present? && issue_date < Time.zone.today

    errors.add(:issue_date, 'deve ser a partir de hoje.')
  end
end
