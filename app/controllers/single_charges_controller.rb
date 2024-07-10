class SingleChargesController < ApplicationController
  before_action :set_condo, only: [:new, :create]

  def show
    @single_charge = SingleCharge.find(params[:id])
  end

  def new
    @single_charge = SingleCharge.new
  end

  def create
    @single_charge = SingleCharge.new(single_charge_params)
    if @single_charge.save
      
      redirect_to condo_single_charge_path(@condo.id, @single_charge), notice: I18n.t('success_notice_single_charge')
    end
  end

  private

  def single_charge_params
    params.require(:single_charge).permit(:description, :value, :unit_id, :charge_type, :issue_date)
  end

  def set_condo
    @condo = Condo.find(params[:condo_id])
  end
end
