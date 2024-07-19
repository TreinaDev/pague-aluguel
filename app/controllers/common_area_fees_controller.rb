class CommonAreaFeesController < ApplicationController
  before_action :authenticate_admin!
  before_action :admin_authorized?, only: [:new, :create]
  before_action :set_common_area, only: [:new, :create]

  def new
    @common_area_fee = CommonAreaFee.new
  end

  def create
    @common_area_fee = current_admin.common_area_fees.new(common_area_fee_params)
    if @common_area_fee.save
      redirect_to common_area, notice: I18n.t('messages.registered_fee')
    else
      flash[:alert] = I18n.t 'messages.registration_fee_error'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def common_area_fee_params
    params.require(:common_area_fee).permit(:value, :common_area_id, :condo_id)
  end

  def set_common_area
    @condo_id = params[:condo_id]
    @common_area_id = params[:common_area_id]
    @common_area = CommonArea.find(@common_area_id)
  end

  def common_area
    condo_common_area_path params[:condo_id], params[:common_area_id]
  end
end
