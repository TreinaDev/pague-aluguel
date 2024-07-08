# frozen_string_literal: true

# rubocop:disable Rails/LexicallyScopedActionFilter

class Admins::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:new, :create]
  before_action :configure_account_update_params, only: [:edit, :update]
  before_action :redirect_if_not_logged_in
  skip_before_action :require_no_authentication

  # GET /resource/sign_up
  # def new
  #  super
  # end

  # POST /resource
  # def create
  #  super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def sign_up(*)
    true
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :document_number, :photo])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :photo])
  end

  def redirect_if_not_logged_in
    redirect_to new_admin_session_path, notice: I18n.t('errors.messages.must_be_logged_in') unless admin_signed_in?
  end

  def after_sign_up_path_for(*)
    root_path
  end

  def after_update_path_for(*)
    root_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
# rubocop:enable Rails/LexicallyScopedActionFilter
