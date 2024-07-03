class BaseFee < ApplicationRecord
  belongs_to :condo
  has_many :values, dependent: :destroy
  has_many :unit_types, through: :values

  accepts_nested_attributes_for :values
  validates :name, :description, :charge_day, presence: true
  validates :interest_rate, numericality: { greater_than_or_equal_to: 0 }
  validate :date_is_future?

  monetize :late_fine_cents,
           allow_nil: false,
           numericality: {
             greater_than_or_equal_to: 0
           }

  enum recurrence: {
    monthly: 0,
    biweekly: 2,
    bimonthly: 4,
    semi_annual: 6,
    yearly: 8
  }

  def value_builder
    @values = []
    condo.unit_types.each do |ut|
      @values << values.build(unit_type: ut)
    end
    @values
  end

  def date_is_future?
    errors.add(:charge_day, :future_date) if charge_day.present? && charge_day < Time.zone.today
  end
end
