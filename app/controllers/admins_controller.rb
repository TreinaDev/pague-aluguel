class AdminsController < ApplicationController
  def index
    @admins = Admin.where.not(id: current_admin.id) if current_admin
    @recent_admins = @admins.order(created_at: :desc).limit(3)
    @admins = @admins.where.not(id: @recent_admins.pluck(:id)).order(first_name: :asc)
    @admins = @admins.where.not(id: current_admin.id) if current_admin
  end
end
