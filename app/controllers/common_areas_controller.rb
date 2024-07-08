class CommonAreasController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_condo, only: [:index, :show, :edit, :update]
  before_action :find_common_area, only: [:edit, :show, :update]

  def index
    @common_areas = CommonArea.all(@condo.id)
    @first_common_areas = @common_areas.take(4)
    @common_areas = @common_areas.excluding(@first_common_areas)
  end

  def show
    @common_area_fee = CommonAreaFee.where(common_area_id: @common_area.id).last
    # @common_area_fee_histories = @common_area.common_area_fee_histories.order(created_at: :desc)
  end

  # def edit; end

  # def update
  #   if @common_area.update(common_area_params)
  #     update_common_area_history
  #     redirect_to condo_common_area_path(@condo.id, @common_area), notice: I18n.t('messages.registered_fee')
  #   else
  #     @common_area_errors = @common_area.errors.full_messages
  #     flash.now[:alert] = I18n.t('messages.registration_fee_error)
  #     render :edit, status: :conflict
  #   end
  # end

  private

  def find_condo
    @condo = Condo.find(params[:condo_id])
  end

  def common_area_params
    params.require(:common_area).permit(:fee)
  end

  def find_common_area
    @common_area = CommonArea.find(@condo.id, params[:id])
  end

  def update_common_area_history
    @common_area.common_area_fee_histories.last.update(user: current_admin.email)
  end
end
