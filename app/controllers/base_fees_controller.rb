class BaseFeesController < ApplicationController
  before_action :authenticate_admin!

  def new
    @condo = Condo.find(params[:condo_id])
    @base_fee = BaseFee.new(condo: @condo)
    @values = @base_fee.value_builder
  end

  def create
    @condo = Condo.find(params[:condo_id])
    @base_fee = @condo.base_fees.build(base_fee_params)

    if @base_fee.save
      redirect_to condo_base_fee_path(@condo, @base_fee), notice: 'Taxa cadastrada com sucesso!'
    else
      flash.now[:alert] = 'Taxa não cadastrada.'
      render :new, status: 412
    end
  end

  def show
    @base_fee = BaseFee.find(params[:id])
    @condo = @base_fee.condo
    @values = Value.where(base_fee: @base_fee)
  end

  private

  def base_fee_params
    params.require(:base_fee).permit(:name, :description, :late_payment, :late_fee,
                                    :fixed, :charge_day, :recurrence,
                                    values_attributes: [:price_cents, :unit_type_id])
  end
end
