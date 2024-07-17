class GenerateMonthlyBillJob < ApplicationJob
  queue_as :default

  def perform(unit, condo_id)
    bill = Bill.new(unit_id: unit.id, condo_id:)
    bill.issue_date = Time.zone.today.beginning_of_month
    bill.due_date = Time.zone.today.beginning_of_month + 9.days
    calculate_values(bill, unit)

    bill.save!
  end

  private

  def calculate_values(bill, unit)
    bill.base_fee_value_cents = BillCalculator.calculate_base_fees(unit.unit_type_id)
    bill.shared_fee_value_cents = BillCalculator.calculate_shared_fees(unit.id)
    bill.total_value_cents = BillCalculator.calculate_total_fees(unit)
  end
end
