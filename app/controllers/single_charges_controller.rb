class SingleChargesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_condo, only: [:index, :show, :new, :create, :cancel]
  before_action :set_common_areas, only: [:new, :create]

  def index
    @single_charges = SingleCharge.where(condo_id: @condo.id).order(issue_date: :desc)
  end

  def show
    @single_charge = SingleCharge.find(params[:id])
    return unless @single_charge.common_area_fee?

    @common_area = CommonArea.find(@single_charge.common_area_id)
  end

  def new
    @single_charge = SingleCharge.new
    @units = Unit.all(@condo.id)
  end

  def create
    @single_charge = SingleCharge.new(single_charge_params)
    @units = Unit.all(@condo.id)
    @single_charge.condo_id = @condo.id
    if @single_charge.save
      redirect_to condo_path(@condo.id), notice: I18n.t('success.create.charge')
    else
      flash.now[:alert] = I18n.t('errors.cant_create.charge')
      render :new, status: :unprocessable_entity
    end
  end

  def cancel
    @single_charge = SingleCharge.find(params[:id])
    @single_charge.canceled!
    redirect_to condo_single_charges_path(@condo.id),
                notice: I18n.t("success.cancel.this_charge.#{@single_charge.charge_type}")
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
