class BillsController < ApplicationController
  before_action :set_condo, only: [:index]
  before_action :set_bill, only: [:show]

  def index
    @bills = Bill.where(condo_id: @condo.id)
  end

  def show
  end

  private

  def set_bill
    @bill = Bill.find(params[:id])
  end

  def set_condo
    @condo = Condo.find(params[:condo_id])
  end
end
