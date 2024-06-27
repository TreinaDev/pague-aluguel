class SharedFee < ApplicationRecord
  after_create :calculate_fractions

  belongs_to :condo
  has_many :shared_fee_fractions, dependent: :destroy

  validates :description, :issue_date, :total_value_cents, presence: true
  validate :date_is_future, on: :create

  monetize :total_value_cents,
           allow_nil: false,
           numericality: {
             greater_than: 0
           }

  def calculate_fractions
    condo.units.each do |unit|
      value_cents = unit.unit_type.ideal_fraction * total_value_cents
      shared_fee_fractions.create!(unit:, value_cents:)
    end
  end

  private

  def date_is_future
    return unless issue_date.present? && issue_date < Time.zone.today

    errors.add(:issue_date, 'deve ser a partir de hoje.')
  end
end
