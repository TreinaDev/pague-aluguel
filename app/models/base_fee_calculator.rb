class BaseFeeCalculator
  def self.total_value(unit_type_id)
    total_value = 0

    get_last_month_values(unit_type_id).each do |value|
      next unless check_recurrence(value.base_fee)

      total_value += if value.base_fee.biweekly?
                       (value.price_cents * 2)
                     else
                       value.price_cents
                     end
    end
    total_value
  end

  def self.get_last_month_values(unit_type_id)
    now = Time.zone.now
    last_month = now.last_month
    start_of_last_month = last_month.beginning_of_month
    end_of_last_month = last_month.end_of_month
    Value.where(unit_type_id:)
         .joins(:base_fee)
         .where(base_fees: { charge_day: ...end_of_last_month })
         .where(base_fees: { status: :active })
  end

  def self.check_recurrence(base_fee)
    recurrence = base_fee.recurrence

    return check_monthly_recurrence(base_fee) if %w[bimonthly monthly biweekly].include?(recurrence)

    check_yearly_recurrence(base_fee) if %w[semi_annual yearly].include?(recurrence)
  end

  def self.check_yearly_recurrence(base_fee)
    current_date = Time.zone.today
    charge_day = base_fee.charge_day
    recurrence = base_fee.recurrence

    last_month = current_date.last_month
    return ((last_month.month - charge_day.month) % 6).zero? if recurrence == 'semi_annual'

    return last_month.month == charge_day.month if recurrence == 'yearly'

    false
  end

  def self.check_monthly_recurrence(base_fee)
    current_date = Time.zone.today
    charge_day = base_fee.charge_day
    recurrence = base_fee.recurrence

    if recurrence == 'bimonthly'
      return current_date.last_month.month.even? if charge_day.month.even?
      return current_date.last_month.month.odd? if charge_day.month.odd?
    end

    true
  end

  private_class_method :check_monthly_recurrence, :check_yearly_recurrence, :check_recurrence, :get_last_month_values
end
