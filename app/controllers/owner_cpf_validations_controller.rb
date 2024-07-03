class OwnerCpfValidationsController < ApplicationController
  def new; end

  def create
    cpf = params[:cpf]
    if cpf_valid?(cpf)
      session[:cpf_is_valid] = true
      flash[:document_id] = cpf
      redirect_to new_property_owner_registration_path
    else
      flash.now[:alert] = I18n.t 'devise.failure.invalid_document_id'
      render :new, status: :not_found
    end
  end

  private

  def cpf_valid?(cpf)
    url = "http://localhost:3000/api/v1/property?cpf=#{cpf}"
    response = Faraday.get(url)
    return true if response.status == 200

    false
  end
end
