class CommonAreasController < ApplicationController
  before_action :authenticate_admin!
  before_action :admin_authorized?
  before_action :find_condo
  before_action :find_common_area, only: [:show]

  def index
    @common_areas = CommonArea.all(@condo.id)
    @first_common_areas = @common_areas.take(4)
    @common_areas = @common_areas.excluding(@first_common_areas)
  end

  def show
    @common_area_fee_histories = CommonAreaFee.where(common_area_id: @common_area.id).order(created_at: :desc)
    @common_area_fee = @common_area_fee_histories.first
  end

  private

  def find_condo
    @condo = Condo.find(params[:condo_id])
  rescue StandardError
    redirect_to root_path, alert: I18n.t('views.index.no_condo')
  end

  def find_common_area
    @common_area = CommonArea.find(params[:id])
  rescue StandardError
    redirect_to condo_path(@condo.id), alert: I18n.t('views.show.no_common_area')
  end
end
