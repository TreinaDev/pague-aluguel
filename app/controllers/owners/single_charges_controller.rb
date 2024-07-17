class Owners::SingleChargesController < ApplicationController
  def new
    @units = Unit.find_all_by_owner(current_property_owner.document_number)
    @single_charge = SingleCharge.new
  end

  def create
    @single_charge = SingleCharge.new(single_charge_params)
    @single_charge.condo_id = Unit.find(@single_charge.unit_id).condo_id
    if @single_charge.save
      flash[:notice] = 'Cobrança Avulsa cadastrada com sucesso!'
      redirect_to owners_single_charge_path(@single_charge)
    else
      @units = Unit.find_all_by_owner(current_property_owner.document_number)
      render :new
    end
  end

  private

  def single_charge_params
    params.require(:single_charge).permit(:description, :value, :unit_id, :charge_type, :issue_date)
  end
end
