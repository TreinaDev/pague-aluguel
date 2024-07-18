class Owners::SingleChargesController < ApplicationController
  before_action :authenticate_property_owner!
  before_action :verify_ownership, only: [:create]

  def index
    @single_charges = SingleCharge.where(
      unit_id: Unit.find_all_by_owner(current_property_owner.document_number).map(&:id)
    ).order(created_at: :desc)
  end

  def new
    @units = Unit.find_all_by_owner(current_property_owner.document_number)
    @single_charge = SingleCharge.new
  end

  def create
    @single_charge = SingleCharge.new(single_charge_params)
    if @single_charge.save
      @single_charge.update(condo_id: Unit.find(@single_charge.unit_id).condo_id)
      redirect_to owners_single_charges_path, notice: I18n.t('success_notice_single_charge')
    else
      @units = Unit.find_all_by_owner(current_property_owner.document_number)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def verify_ownership
    owner_units = Unit.find_all_by_owner(current_property_owner.document_number)
    unit_id = single_charge_params[:unit_id]
    return if unit_id.blank?
    return if owner_units.any? { |unit| unit.id == unit_id.to_i }

    redirect_to root_path, notice: I18n.t('not_authorized_notice_single_charge')
  end

  def single_charge_params
    params.require(:single_charge).permit(:description, :value, :unit_id, :charge_type, :issue_date)
  end
end
