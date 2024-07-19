class ApplicationController < ActionController::Base
  protected

  def admin_authorized?
    if admin_signed_in?
      current_admin_associated = current_admin.associated_condos.map(&:condo_id).include?(params[:id].to_i)
      return true if current_admin.super_admin? || current_admin_associated
    end

    redirect_to root_path, notice: I18n.t('errors.messages.must_be_super_admin')
  end
end
