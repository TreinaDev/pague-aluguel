class BaseFee < ApplicationRecord
  belongs_to :condo
  has_many :values
  has_many :unit_type, through: :values

  accepts_nested_attributes_for :values
  validates :name, :description, :late_payment, :late_fee, :charge_day, presence: true

  enum recurrence: {
    monthly: 0,
    biweekly: 2,
    bimonthly: 4,
    semi_annual: 6,
    yearly: 8
  }

  def value_builder
    @values = []
    self.condo.unit_types.each do |ut|
      @values << self.values.build(unit_type: ut)
    end
    @values
  end
end
