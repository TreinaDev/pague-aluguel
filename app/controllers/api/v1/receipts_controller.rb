class Api::V1::ReceiptsController < Api::V1::ApiController
  before_action :validate_file_presence, only: [:create]
  before_action :validate_bill_id_presence, only: [:create]

  def create
    receipt = Receipt.new(bill_id: params[:bill_id])
    receipt.file.attach(params[:receipt])

    if receipt.save
      render_response({ message: I18n.t('receipt_received_success') }, :ok)
    else
      render_response({ errors: receipt.errors.full_messages }, :unprocessable_entity)
    end
  end

  private

  def validate_file_presence
    render_response({ error: I18n.t('no_file_sent') }, :bad_request) if params[:receipt].blank?
  end

  def validate_bill_id_presence
    render_response({ error: I18n.t('missing_bill_id') }, :unprocessable_entity) if params[:bill_id].blank?
  end

  def render_response(body, status)
    render json: body, status:
  end
end
