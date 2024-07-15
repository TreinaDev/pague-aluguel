class Api::V1::CommonAreaFeesController < Api::V1::ApiController
  def index
    condo_id = params[:condo_id]
    common_area_fees = find_most_recent_fee(condo_id)

    render status: :ok, json: common_area_fees.as_json(except: [:updated_at, :admin_id, :id])
  end

  def show
    id = params[:id]

    common_area_fee = CommonAreaFee.find(id)
    render status: :ok, json: common_area_fee.as_json(except: [:updated_at, :admin_id, :id])
  end

  private

  def find_most_recent_fee(condo_id)
    fees = CommonAreaFee.where(condo_id:)
    current_fees = []
    fees.each do |fee|
      next if current_fees.any? { |last_fee| last_fee.common_area_id == fee.common_area_id }

      current_fees << fees.where(common_area_id: fee.common_area_id).last
    end
    current_fees
  end
end
