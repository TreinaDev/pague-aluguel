class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found
    render status: :not_found, json: { errors: 'Não encontrado' }
  end
end
