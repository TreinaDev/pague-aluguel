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
    bill.total_value_cents = BillCalculator.calculate_total_fees(unit)
    bill.issue_date = Time.zone.today.beginning_of_month
    bill.due_date = Time.zone.today.beginning_of_month + 9.days
    bill.save!
  end
end
