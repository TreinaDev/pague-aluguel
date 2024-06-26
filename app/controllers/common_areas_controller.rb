class CommonAreasController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_common_area, only: %i[edit show update]

  def index
    @common_areas = CommonArea.all
  end

  def show; end

  def edit; end

  def update
    if @common_area.update(common_area_params)
      redirect_to @common_area, notice: I18n.t('messages.registered_fee')
    else
      @common_area_errors = @common_area.errors.full_messages
      flash.now[:alert] = I18n.t 'messages.registration_error'
      render :edit, status: :conflict
    end
  end

  private

  def common_area_params
    params.require(:common_area).permit(:fee)
  end

  def find_common_area
    @common_area = CommonArea.find(params[:id])
  end
end
