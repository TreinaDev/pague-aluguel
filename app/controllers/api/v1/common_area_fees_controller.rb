class Api::V1::CommonAreaFeesController < Api::V1::ApiController
  def index
    condo_id = params[:condo_id]
    common_area_fees = CommonAreaFee.where(condo_id:)

    render status: :ok, json: common_area_fees.as_json(except: [:updated_at, :admin_id, :id])
  end

  def show
    id = params[:id]

    common_area_fee = CommonAreaFee.find(id)
    render status: :ok, json: common_area_fee.as_json(except: [:updated_at, :admin_id, :id])
  end
end
