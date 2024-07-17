class RentFeesController < ApplicationController
  before_action :authenticate_property_owner!
  before_action :set_unit, only: [:new, :create, :edit, :update]
  before_action :verify_ownership, only: [:new, :create, :edit, :update]

  def deactivate
    @rent_fee = RentFee.find(params[:id])
    @rent_fee.update_column(:status, RentFee.statuses[:canceled])
    redirect_to unit_path(@rent_fee.unit_id), notice: I18n.t('messages.deactivated_fee')
  end

  def new
    @rent_fee = RentFee.new
  end

  def edit
    @rent_fee = RentFee.find(params[:id])
  end

  def create
    @rent_fee = RentFee.new(rent_fee_params)
    if @rent_fee.save
      redirect_to unit_path(@unit_id), notice: I18n.t('messages.registered_fee')
    else
      flash[:alert] = I18n.t 'messages.registration_fee_error'
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @rent_fee = RentFee.find(params[:id])
    if @rent_fee.update(rent_fee_params)
      redirect_to unit_path(@unit_id), notice: I18n.t('messages.updated_fee')
    else
      flash[:alert] = I18n.t 'messages.update_fee_error'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def rent_fee_params
    params.require(:rent_fee).permit(:value, :unit_id, :condo_id, :tenant_id, :owner_id, :issue_date, :fine,
                                     :fine_interest)
  end

  def set_unit
    @unit = Unit.find(params[:unit_id])
    @unit_id = @unit.id
  end

  def verify_ownership
    owner_units = Unit.find_all_by_owner(current_property_owner.document_number)
    return if owner_units.any? { |unit| unit.id == @unit_id }

    redirect_to(root_url, alert: I18n.t('messages.not_authorized'))
  end
end
