class GenerateMonthlyBillJob < ApplicationJob
  queue_as :default

  def perform(unit)
    bill = Bill.new(unit_id: unit.id)
    unit_type = UnitType.find(unit.unit_type_id)
    bill.condo_id = unit_type.condo_id
    bill.total_value_cents = BillCalculator.calculate_total_fees(unit)
    bill.issue_date = Time.zone.today.beginning_of_month
    bill.due_date = Time.zone.today.beginning_of_month + 9.days
    bill.save!
  end
end
