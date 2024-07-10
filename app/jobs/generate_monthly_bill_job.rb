class GenerateMonthlyBillJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    condos = Condo.all
    condos.each do |condo|
      units = Unit.find_all_by_condo(condo.id)
      units.each do |unit|
        generate_bill_for_unit(unit)
      end
    end
  end

  private

  def generate_bill_for_unit(unit)
    bill = Bill.new(unit_id: unit.id)
    bill.total_value_cents = calculate_total_fees(unit)
    bill.issue_date = Time.zone.today.beginning_of_month
    bill.due_date = Time.zone.today.beginning_of_month + 9.days
    bill.save!
  end

  def calculate_total_fees(unit)
    base_fees = calculate_base_fees(unit.unit_type_id)
    shared_fees = calculate_shared_fees(unit.id)
    base_fees + shared_fees
  end

  def calculate_base_fees(unit_type_id)
    total_value = 0
    get_last_month_values(unit_type_id).each do |value|
      next unless check_recurrence(value)

      total_value += if value.base_fee.biweekly?
                       (value.price_cents * 2)
                     else
                       value.price_cents
                     end
    end
    total_value
  end

  def get_last_month_values(unit_type_id)
    now = Time.zone.now
    last_month = now.last_month
    start_of_last_month = last_month.beginning_of_month
    end_of_last_month = last_month.end_of_month
    Value.where(unit_type_id:)
         .joins(:base_fee)
         .where(base_fees: { charge_day: ...now })
         .where(base_fees: { charge_day: start_of_last_month..end_of_last_month })
  end

  def check_recurrence(value)
    current_date = Time.zone.today
    charge_day = value.base_fee.charge_day
    recurrence = value.base_fee.recurrence
    return true if %w[monthly biweekly].include?(recurrence)
    return (charge_day.month.even? == current_date.month.even?) if recurrence == 'bimonthly'
    return (charge_day.month.odd? == current_date.month.odd?) if recurrence == 'bimonthly'
    return ((current_date.month - charge_day.month) % 6).zero? if recurrence == 'semiannual'
    return current_date.year != charge_day.year if recurrence == 'yearly'

    false
  end

  def calculate_shared_fees(unit_id)
    total_value = 0
    shared_fees = SharedFeeFraction.where(unit_id:)
    shared_fees.each do |shared_fee|
      total_value += shared_fee.value_cents
    end
    total_value
  end
end
