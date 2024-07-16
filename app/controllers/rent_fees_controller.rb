class RentFeesController < ApplicationController
  def new
    @unit = Unit.find(params[:unit_id])
    @unit_id = @unit.id
    @rent_fee = RentFee.new
  end

  def edit; end

  def create
    @unit = Unit.find(params[:unit_id])
    @unit_id = @unit.id
    @rent_fee = RentFee.new(rent_fee_params)
    if @rent_fee.save
      redirect_to unit_path(@unit_id), notice: I18n.t('messages.registered_fee')
    else
      flash[:alert] = I18n.t 'messages.registration_fee_error'
      render :new, status: :unprocessable_entity
    end
  end

  def update; end

  private

  def rent_fee_params
    params.require(:rent_fee).permit(:value, :unit_id, :condo_id, :tenant_id, :owner_id, :issue_date, :fine,
                                     :fine_interest)
  end
end
