class CommonAreasController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_common_area, only: %i[edit show]

  def index
    @common_areas = CommonArea.all
  end

  def show; end

  def edit; end

  private

  def find_common_area
    @common_area = CommonArea.find(params[:id])
  end
end
