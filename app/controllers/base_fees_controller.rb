class BaseFeesController < ApplicationController
  before_action :authenticate_admin!, only: [:new, :create]

  def new
    @condo = Condo.find(params[:condo_id])
    @base_fee = BaseFee.new
    @condos = Condo.all
    @value = @base_fee.values.new
  end

  def create

  end
end
