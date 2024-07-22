class Api::V1::ReceiptsController < Api::V1::ApiController
  before_action :validate_file_presence, only: [:create]
  before_action :validate_bill_id_presence, only: [:create]
  before_action :check_older_receipt, only: [:create]
  before_action :obtain_url_received, only: [:create]
  before_action :response_after_redirects, only: [:create]

  def create
    return unless @response.success?

    if receipt.save
      render_response({ message: I18n.t('receipts.success.received') }, :ok)
    else
      render_response({ errors: receipt.errors.full_messages }, :unprocessable_entity)
    end
    send_render_reponse
  end

  private

  def validate_file_presence
    render_response({ error: I18n.t('receipts.errors.no_file_sent') }, :bad_request) if params[:receipt].blank?
  end

  def validate_bill_id_presence
    return if params[:bill_id].present?

    render_response({ error: I18n.t('receipts.errors.missing_bill_id') }, :unprocessable_entity)
  end

  def render_response(body, status)
    render json: body, status:
  end

  def obtain_url_received
    @url = params[:receipt]
  end

  def check_older_receipt
    @receipt = Receipt.find_by(bill_id: params[:bill_id])
    @receipt = Receipt.new(bill_id: params[:bill_id]) if @receipt.nil?
  end

  def response_after_redirects
    @response = Receipt.follow_redirects(@url)
  end

  def send_render_reponse
    filename = File.basename(URI.parse(@url).path)
    content_type = @response.headers['content-type']
    if @receipt.file.attach(io: StringIO.new(@response.body), filename:, content_type:) && @receipt.save
      bill_awaiting(@receipt)
      render_response({ message: I18n.t('receipt_received_success') }, :ok)
    else
      render_response({ errors: @receipt.errors.full_messages }, :unprocessable_entity)
    end
  end

  def bill_awaiting(receipt)
    bill = receipt.bill
    bill.denied = false if bill.denied?
    bill.awaiting!
  end
end
