class BillCalculator
  def self.calculate_total_fees(unit)
    base_fees = calculate_base_fees(unit.unit_type_id)
    shared_fees = calculate_shared_fees(unit.id)
    base_fees + shared_fees
  end

  def self.calculate_base_fees(unit_type_id)
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

  def self.calculate_shared_fees(unit_id)
    total_value = 0
    fractions = get_last_month_fractions(unit_id)
    fractions.each do |fraction|
      total_value += fraction.value_cents
    end
    total_value
  end

  def self.get_last_month_fractions(unit_id)
    now = Time.zone.now
    last_month = now.last_month
    start_of_last_month = last_month.beginning_of_month
    end_of_last_month = last_month.end_of_month
    SharedFeeFraction.where(unit_id:)
                     .joins(:shared_fee)
                     .where(shared_fees: { issue_date: ...now })
                     .where(shared_fees: { issue_date: start_of_last_month..end_of_last_month })
  end

  def self.get_last_month_values(unit_type_id)
    now = Time.zone.now
    last_month = now.last_month
    start_of_last_month = last_month.beginning_of_month
    end_of_last_month = last_month.end_of_month
    Value.where(unit_type_id:)
         .joins(:base_fee)
         .where(base_fees: { charge_day: ...now })
         .where(base_fees: { charge_day: start_of_last_month..end_of_last_month })
  end

  def self.check_recurrence(base_fee)
    recurrence = base_fee.recurrence

    return check_monthly_recurrence(base_fee) if %w[bimonthly monthly biweekly].include?(recurrence)
    return check_yearly_recurrence(base_fee) if %w[semiannual yearly].include?(recurrence)

    false
  end

  def self.check_yearly_recurrence(base_fee)
    current_date = Time.zone.today
    charge_day = base_fee.charge_day
    recurrence = base_fee.recurrence

    return ((current_date.month - charge_day.month) % 6).zero? if recurrence == 'semiannual'
    return current_date.year != charge_day.year if recurrence == 'yearly'

    false
  end

  def self.check_monthly_recurrence(base_fee)
    current_date = Time.zone.today
    charge_day = base_fee.charge_day
    recurrence = base_fee.recurrence

    if recurrence == 'bimonthly'
      return current_date.month.even? if charge_day.month.even?
      return current_date.month.odd? if charge_day.month.odd?
    end

    true
  end

  private_class_method :check_monthly_recurrence, :check_yearly_recurrence, :check_recurrence, :get_last_month_values,
                       :get_last_month_fractions
end
