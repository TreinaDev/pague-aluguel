class BaseFeesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_condo, only: [:new, :create, :index, :cancel]

  def index
    @base_fees = BaseFee.where(condo_id: @condo.id).order(charge_day: :desc)
  end

  def show
    @base_fee = BaseFee.find(params[:id])
    @condo = Condo.find(@base_fee.condo_id)
    @values = Value.where(base_fee: @base_fee)
    @unit_types = UnitType.all(@condo.id)
  end

  def new
    @base_fee = BaseFee.new(condo_id: @condo.id)
    @values = @base_fee.value_builder
    @unit_types = UnitType.all(@condo.id)
  end

  def create
    @base_fee = BaseFee.new(base_fee_params)
    @unit_types = UnitType.all(@condo.id)

    if @base_fee.save
      redirect_to condo_path(@condo.id), notice: I18n.t('success_notice_base_fee')
    else
      flash.now[:alert] = I18n.t('fail_notice_base_fee')
      render :new, status: :unprocessable_entity
    end
  end

  def cancel
    @base_fee = BaseFee.find(params[:id])
    @base_fee.canceled!
    redirect_to condo_base_fees_path(@condo.id),
                notice: I18n.t('cancel_notice_base_fee', base_fee: @base_fee.name)
  end

  private

  def base_fee_params
    params.require(:base_fee).permit(:name, :description, :interest_rate, :late_fine,
                                     :limited, :installments, :charge_day, :recurrence, :condo_id,
                                     values_attributes: [:price, :unit_type_id])
  end

  def set_condo
    @condo = Condo.find(params[:condo_id])
  end
end
