class CommonAreaFeesController < ApplicationController
  before_action :authenticate_admin!

  def new
    @condo_id = params[:condo_id]
    @common_area_id = params[:common_area_id]
    @common_area_fee = CommonAreaFee.new
  end

  def create
    @common_area_fee = current_admin.common_area_fees.new(common_area_fee_params)
    if @common_area_fee.save
      flash[:notice] = I18n.t 'messages.common_area_fee.registered_fee'
      redirect_to condo_common_area_path(params[:condo_id], params[:common_area_id])
    else
      @common_area_fee_errors = @common_area_fee.errors.full_messages
      @condo_id = params[:condo_id]
      @common_area_id = params[:common_area_id]
      flash[:alert] = I18n.t 'messages.common_area_fee.registration_error'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def common_area_fee_params
    params.require(:common_area_fee).permit(:value, :common_area_id)
  end
end
