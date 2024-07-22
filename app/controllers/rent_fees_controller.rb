class RentFeesController < ApplicationController
  before_action :authenticate_property_owner!
  before_action :set_rent_fee, only: [:deactivate, :edit, :update]
  before_action :set_unit, only: [:new, :create, :edit, :update]
  before_action :verify_ownership, only: [:new, :create, :edit, :update]

  def deactivate
    @rent_fee.canceled!
    redirect_to unit_path(@rent_fee.unit_id), notice: I18n.t('success.deactivate.rent')
  end

  def new
    @rent_fee = RentFee.new
  end

  def edit; end

  def create
    @rent_fee = RentFee.new(rent_fee_params)
    if @rent_fee.save
      redirect_to unit_path(@unit_id), notice: I18n.t('success.create.rent')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @rent_fee.update(rent_fee_params)
      reactivate
      redirect_to unit_path(@unit_id), notice: I18n.t('success.update.rent')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def rent_fee_params
    params.require(:rent_fee).permit(:value, :unit_id, :condo_id, :tenant_id, :owner_id, :issue_date, :fine,
                                     :fine_interest)
  end

  def set_rent_fee
    @rent_fee = RentFee.find(params[:id])
  end

  def set_unit
    @unit = Unit.find(params[:unit_id])
    @unit_id = @unit.id
  end

  def reactivate
    @rent_fee.active! if @rent_fee.canceled?
  end

  def verify_ownership
    owner_units = Unit.find_all_by_owner(current_property_owner.document_number)
    return if owner_units.any? { |unit| unit.id == @unit_id }

    redirect_to root_path, alert: I18n.t('errors.unauthorized.access')
  end
end
