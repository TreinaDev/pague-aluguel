class CondosController < ApplicationController
  before_action :authenticate_admin!

  def index
    @condos = Condo.all
    @recent_condos = @condos.sort_by(&:name).take(4)
    @condos = @condos.excluding(@recent_condos)
  end

  def show
    @condo = Condo.find(params[:id])
    @common_areas = CommonArea.all(@condo.id)
    @first_common_areas = @common_areas.take(4)
  end
end
