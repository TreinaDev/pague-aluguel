class BillsController < ApplicationController
  before_action :set_condo, only: [:index]
  
  def index
  end

  def set_condo
    @condo = Condo.find(params[:condo_id])
  end
end
