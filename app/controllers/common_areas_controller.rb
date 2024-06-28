class CommonAreasController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_common_area, only: %i[edit show update]

  def index
    @condo = Condo.find(params[:condo_id])
    @common_areas = @condo.common_areas
  end

  def show; end

  def edit; end

  def update
    if @common_area.update(common_area_params)
      update_common_area_history
      redirect_to condo_common_area_path(@common_area.condo, @common_area), notice: t('messages.registered_fee')
    else
      @common_area_errors = @common_area.errors.full_messages
      flash.now[:alert] = t 'messages.registration_error'
      render :edit, status: :conflict
    end
  end

  private

  def common_area_params
    params.require(:common_area).permit(:fee_cents)
  end

  def find_common_area
    @common_area = CommonArea.find(params[:id])
  end

  def update_common_area_history
    @common_area.common_area_fee_histories.last.update(user: current_admin.email)
  end
end
