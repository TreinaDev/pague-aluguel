class GenerateMonthlyBillJob < ApplicationJob
  queue_as :default

  def perform(unit, condo_id)
    bill = Bill.new(unit_id: unit.id, condo_id:)
    bill = unit.calculate_values(bill)
    bill.issue_date = Time.zone.today.beginning_of_month
    bill.due_date = Time.zone.today.beginning_of_month + 9.days
    bill.save!
    BillCalculator.generate_bill_details(bill)
  end
end
