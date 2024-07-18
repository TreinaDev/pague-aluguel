class Api::V1::ReceiptsController < Api::V1::ApiController
  def create
    file = params[:receipt]
    if file
      receipt = build_receipt(file)
      save_receipt(receipt)
    else
      render_bad_request_response('Nenhum arquivo foi enviado.')
    end
  end

  private

  def build_receipt(file)
    receipt = Receipt.new
    receipt.file.attach(file)
    receipt
  end

  def save_receipt(receipt)
    if receipt.save
      render_success_response
    else
      render_error_response(receipt.errors.full_messages)
    end
  end

  def render_success_response
    render json: { message: 'Comprovante recebido com sucesso.' }, status: :ok
  end

  def render_error_response(errors)
    render json: { errors: }, status: :unprocessable_entity
  end

  def render_bad_request_response(error)
    render json: { error: }, status: :bad_request
  end
end
