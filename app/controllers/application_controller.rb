class ApplicationController < ActionController::Base
  rescue_from Faraday::ConnectionFailed, with: :connection_refused

  protected

  def connection_refused
    redirect_to server_unreachable_path
  end

  def admin_authorized?
    if admin_signed_in?
      current_admin_associated = current_admin.associated_condos.map(&:condo_id).include?(params[:condo_id].to_i)
      return true if current_admin&.super_admin? || current_admin_associated
    end

    redirect_to root_path, notice: I18n.t('errors.unauthorized.not_super_admin')
  end
end
