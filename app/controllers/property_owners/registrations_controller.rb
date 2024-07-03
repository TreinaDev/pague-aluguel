class PropertyOwners::RegistrationsController < Devise::RegistrationsController
  before_action :check_cpf
  before_action :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:document_id])
  end

  def after_sign_up_path_for(*)
    session.delete(:cpf_is_valid)
    super
  end

  private

  def check_cpf
    return if session[:cpf_is_valid]

    redirect_to new_owner_cpf_validation_path, notice: I18n.t('devise.failure.document_id_not_valideted')
  end
end
