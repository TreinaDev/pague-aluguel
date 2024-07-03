class PropertyOwners::RegistrationsController < Devise::RegistrationsController
  before_action :check_cpf

  protected

  def after_sign_up_path_for(resource)
    session.delete(:cpf_is_valid)
    super(resource)
  end

  private

  def check_cpf
    return if session[:cpf_is_valid]

    redirect_to new_owner_cpf_validation_path, notice: 'Valide seu CPF primeiro'
  end
end
