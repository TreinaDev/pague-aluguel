class AdminsController < ApplicationController
  before_action :set_admin, only: [:show]
  def index
    @admins = Admin.all
    @admins = @admins.where.not(id: current_admin.id) if current_admin
    @recent_admins = @admins.order(created_at: :desc).limit(3)
    @admins = @admins.where.not(id: @recent_admins.pluck(:id)).order(first_name: :asc)
    @admins = @admins.where.not(id: current_admin.id) if current_admin
  end

  def show; end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end
end
