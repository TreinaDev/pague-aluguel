class SingleChargesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_condo, only: [:new, :create, :show]
  before_action :set_common_areas, only: [:new, :create]

  def show
    @single_charge = SingleCharge.find(params[:id])
    return unless @single_charge.charge_type == 'common_area_fee'

    @common_area = CommonArea.find(@condo.id, @single_charge.common_area_id)
  end

  def new
    @single_charge = SingleCharge.new
  end

  def create
    @single_charge = SingleCharge.new(single_charge_params)
    if @single_charge.save
      redirect_to condo_single_charge_path(@condo.id, @single_charge), notice: I18n.t('success_notice_single_charge')
    else
      flash.now[:alert] = I18n.t('fail_notice_single_charge')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def single_charge_params
    params.require(:single_charge).permit(:description, :value, :common_area_id, :unit_id, :charge_type, :issue_date)
  end

  def set_condo
    @condo = Condo.find(params[:condo_id])
  end

  def set_common_areas
    @common_areas = CommonArea.all(@condo.id)
  end
end
