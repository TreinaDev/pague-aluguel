class BaseFeesController < ApplicationController
  before_action :authenticate_admin!

  def new
    @condo = Condo.find(params[:condo_id])
    @unit_types = @condo.unit_types
    @base_fee = BaseFee.new
    @value = @base_fee.values.build
  end

  def create
    @condo = Condo.find(params[:condo_id])
    @base_fee = @condo.base_fees.build(base_fee_params)

    if @base_fee.save
      redirect_to @base_fee, notice: 'Taxa cadastrada com sucesso!'
    else
      render :new
    end
  end

  def show
    @condo = Condo.find(params[:condo_id])
    @base_fee = BaseFee.find(params[:id])
  end

  private

  def base_fee_params
    params.require(:base_fee).permit(:name, :description, :late_payment, :late_fee,
                                    :fixed, :charge_day, :recurrence,
                                    values_attributes: [])
  end
end


