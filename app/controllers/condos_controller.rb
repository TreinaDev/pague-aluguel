class CondosController < ApplicationController
  before_action :authenticate_admin!
  before_action :is_admin_authorized?, only: [:show]

  def index
    if current_admin.super_admin?
      @condos = Condo.all
    else
      condo_ids = current_admin.associated_condos.map(&:condo_id)
      @condos = Condo.all.select { |condo| condo_ids.include?(condo.id) }
    end

    @recent_condos = @condos.sort_by(&:name).take(4)
    @condos = @condos.excluding(@recent_condos)
  end

  def show
    @condo = Condo.find(params[:id])
    @common_areas = CommonArea.all(@condo.id)
    @first_common_areas = @common_areas.take(4)
  end

  private

  def is_admin_authorized?
    unless current_admin.super_admin? || current_admin.associated_condos.map(&:condo_id).include?(params[:id].to_i)
      redirect_to root_path, notice: I18n.t('errors.messages.must_be_super_admin')
    end
  end
end
