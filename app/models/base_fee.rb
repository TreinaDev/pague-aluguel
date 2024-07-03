class BaseFee < ApplicationRecord
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
    UnitType.find_all_by_condo(condo_id).each do |ut|
      @values << values.build(unit_type_id: ut.id)
    end
    @values
  end

  def date_is_future?
    errors.add(:charge_day, :future_date) if charge_day.present? && charge_day <= Time.zone.today
  end
end
