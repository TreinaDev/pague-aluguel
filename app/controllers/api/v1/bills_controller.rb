class Api::V1::BillsController < Api::V1::ApiController
  def show
    id = params[:id]

    bill = Bill.find(id)
    render status: :ok, json: bill_json(bill)
  end

  private

  def bill_json(bill)
    { unit_id: bill.unit_id, condo_id: bill.condo_id, issue_date: bill.issue_date, due_date: bill.due_date,
      total_value_cents: bill.total_value_cents, status: bill.status,
      values: { base_fee_value_cents: bill.base_fee_value_cents, shared_fee_value_cents: bill.shared_fee_value_cents } }
  end
end
