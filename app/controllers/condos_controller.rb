class CondosController < ApplicationController
  before_action :authenticate_admin!
  before_action :admin_authorized?, only: [:show]
  before_action :set_condo, only: [:show]

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
    @common_areas = CommonArea.all(@condo.id)
    @first_common_areas = @common_areas.take(4)
    recent_base_fees
    recent_shared_fees
    recent_single_charges
    recent_bills
  end

  def recent_base_fees
    @recent_base_fees = BaseFee.where(condo_id: @condo.id).order(created_at: :desc).take(2)
  end

  def recent_shared_fees
    @recent_shared_fees = SharedFee.where(condo_id: @condo.id).where.not(status: :canceled)
    @recent_shared_fees = @recent_shared_fees.order(created_at: :desc).take(2)
  end

  def recent_single_charges
    @recent_single_charges = SingleCharge.where(condo_id: @condo.id).order(created_at: :desc).take(2)
  end

  def recent_bills
    @recent_bills = Bill.where(condo_id: @condo.id).order(created_at: :desc).take(2)
  end

  private

  def set_condo
    @condo = Condo.find(params[:id])
  rescue StandardError
    redirect_to root_path, alert: I18n.t('errors.not_found.condos')
  end

  def admin_authorized?
    current_admin_associated = current_admin.associated_condos.map(&:condo_id).include?(params[:id].to_i)
    return true if current_admin.super_admin? || current_admin_associated

    redirect_to root_path, notice: I18n.t('errors.unauthorized.not_super_admin')
  end
end
