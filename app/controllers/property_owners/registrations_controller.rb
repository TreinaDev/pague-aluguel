class PropertyOwners::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  before_action :configure_account_update_params, only: [:edit, :update]

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:document_number, :first_name, :last_name, :photo])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :photo])
  end
end
