class Api::V1::BillsController < Api::V1::ApiController
  def index
    unit_id = params[:unit_id]

    bills = Bill.where(unit_id:, status: 'pending')
    render status: :ok, json: { bills: bills.as_json(only: [:id, :issue_date, :due_date, :total_value_cents]) }
  end

  def show
    id = params[:id]

    bill = Bill.find(id)
    render status: :ok, json: bill_json(bill)
  end

  private

  def bill_json(bill)
    { unit_id: bill.unit_id, condo_id: bill.condo_id, issue_date: bill.issue_date, due_date: bill.due_date,
      total_value_cents: bill.total_value_cents, status: bill.status, denied: bill.denied,
      values: {
        base_fee_value_cents: bill.base_fee_value_cents, shared_fee_value_cents: bill.shared_fee_value_cents,
        single_charge_value_cents: bill.single_charge_value_cents, rent_fee_cents: bill.rent_fee_cents
      },
      bill_details: bill.bill_details.map do |detail|
                      { value_cents: detail.value_cents, description: detail.description, fee_type: detail.fee_type }
                    end }
  end
end
