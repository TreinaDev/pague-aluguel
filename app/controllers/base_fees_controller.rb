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

    # @base_fee.save!

    if @base_fee.save
      # debugger
      redirect_to condo_base_fee_path(@condo, @base_fee), notice: 'Taxa cadastrada com sucesso!'
    else
      flash.now[:alert] = "Não foi possível cadastrar a taxa!"
      render :new, status: 412
    end
  end

  def show
    @base_fee = BaseFee.find(params[:id])
    @condo = @base_fee.condo
  end

  private

  def base_fee_params
    params.require(:base_fee).permit(:name, :description, :late_payment, :late_fee,
                                    :fixed, :charge_day, :recurrence,
                                    values_attributes: [:price, :unit_type_id])
  end
end
