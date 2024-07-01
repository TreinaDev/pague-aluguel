class BaseFeesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_condo, only: [:new, :create, :index]

  def show
    @base_fee = BaseFee.find(params[:id])
    @condo = @base_fee.condo
    @values = Value.where(base_fee: @base_fee)
  end
  def index
    @base_fees = BaseFee.where(condo: @condo)
  end
  def new
    @base_fee = BaseFee.new(condo: @condo)
    @values = @base_fee.value_builder
  end

  def create
    @base_fee = @condo.base_fees.build(base_fee_params)

    if @base_fee.save
      redirect_to condo_base_fee_path(@condo, @base_fee), notice: I18n.t('success_notice_base_fee')
    else
      flash.now[:alert] = I18n.t 'fail_notice_base_fee'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def base_fee_params
    params.require(:base_fee).permit(:name, :description, :late_payment, :late_fee,
                                     :fixed, :charge_day, :recurrence,
                                     values_attributes: [:price_cents, :unit_type_id])
  end

  def set_condo
    @condo = Condo.find(params[:condo_id])
  end
end
