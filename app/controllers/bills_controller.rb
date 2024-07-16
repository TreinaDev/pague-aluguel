class BillsController < ApplicationController
  before_action :set_condo, only: [:index]

  def index
    @bills = Bill.where(condo_id: @condo.id)
  end

  def set_condo
    @condo = Condo.find(params[:condo_id])
  end
end
