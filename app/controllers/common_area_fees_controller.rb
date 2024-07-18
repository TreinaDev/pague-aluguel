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

  def admin_authorized?
    current_admin_associated = current_admin.associated_condos.map(&:condo_id).include?(params[:condo_id].to_i)
    return true if current_admin.super_admin? || current_admin_associated

    redirect_to root_path, notice: I18n.t('errors.messages.must_be_super_admin')
  end

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
