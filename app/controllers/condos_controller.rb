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
    recent_base_fees
    recent_shared_fees
  end

  def recent_base_fees
    @recent_base_fees = BaseFee.where(condo_id: @condo.id).order(created_at: :desc).take(2)
  end

  def recent_shared_fees
    @recent_shared_fees = SharedFee.where(condo_id: @condo.id).where.not(status: :canceled).order(created_at: :desc).take(2)
  end
end
