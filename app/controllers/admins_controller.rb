class AdminsController < ApplicationController
  before_action :set_admin, only: [:show]
  def index
    @admins = Admin.all
  end

  def show; end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end
end
