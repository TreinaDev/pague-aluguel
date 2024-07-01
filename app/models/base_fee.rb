class BaseFee < ApplicationRecord
  belongs_to :condo
  has_many :values, dependent: :destroy
  has_many :unit_types, through: :values

  accepts_nested_attributes_for :values
  validates :name, :description, :late_payment, :late_fee, :charge_day, presence: true
  validate :date_is_future?

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
    errors.add(:charge_day, :future_date) if charge_day.present? && charge_day <= Time.zone.today
  end
end
