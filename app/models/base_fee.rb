class BaseFee < ApplicationRecord
  has_many :values, dependent: :destroy
  has_many :unit_types, through: :values

  accepts_nested_attributes_for :values
  validates :name, :description, :charge_day, presence: true
  validates :interest_rate, numericality: { greater_than_or_equal_to: 0 }
  validate :date_is_future?, on: :create
  validate :installments_apply?
  validates :installments, numericality: { greater_than: 0, allow_nil: true }

  enum status: {
    active: 0,
    paid: 3,
    canceled: 5
  }

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
    unit_types = UnitType.all(condo_id)
    unit_types.each do |ut|
      @values << values.build(unit_type_id: ut.id)
    end
    @values
  end

  def date_is_future?
    errors.add(:charge_day, :future_date) if charge_day.present? && charge_day < Time.zone.today
  end

  def installments_apply?
    errors.add(:installments, :not_limited_fee) if installments.present? && limited? == false
    errors.add(:installments, :is_limited_fee) if installments.blank? && limited?
  end
end
