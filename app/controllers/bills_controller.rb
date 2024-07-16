class BillsController < ApplicationController
  before_action :set_condo, only: [:index, :show]
  before_action :set_bill, only: [:show]

  def index
    @bills = Bill.where(condo_id: @condo.id)
  end

  def show
    set_unit_type
  end

  private

  def set_bill
    @bill = Bill.find(params[:id])
  end

  def set_condo
    @condo = Condo.find(params[:condo_id])
  end

  def set_unit_type
    unit = Unit.find(@bill.unit_id)
    @unit_type = UnitType.find(unit.unit_type_id)
  end
end
