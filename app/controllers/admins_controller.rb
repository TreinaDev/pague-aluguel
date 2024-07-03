class AdminsController < ApplicationController
  before_action :set_admin, only: [:show]
  def index
    @admins = Admin.all
    @recent_admins = Admin.last(3)
    @admins = @admins.where.not(id: @recent_admins.pluck(:id)).order(first_name: :asc)
  end

  def show; end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end
end
