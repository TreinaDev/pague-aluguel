class AssociatedCondosController < ApplicationController
  before_action :is_super_admin?
  # before_action :set_admin

  def new
    @condos = Condo.all
  end

  def create
    if @admin
    end
  end

  def edit
  end

  def update; end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def is_super_admin?
    redirect_to root_path, notice: I18n.t('errors.messages.must_be_super_admin') unless current_admin.super_admin?
  end
end
