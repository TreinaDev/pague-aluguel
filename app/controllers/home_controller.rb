class HomeController < ApplicationController
  before_action :authenticate_admin!, only: [:search]

  rescue_from Tenant::DocumentNumberNotFoundError, Tenant::DocumentNumberNotValidError do |exception|
    flash[:alert] = exception.message
    redirect_to root_path
  end

  def index
    if property_owner_signed_in?
      first_units
      render 'index'
    end

    recent_admins
    first_condos
  end

  def search
    @query = params[:query].downcase
    @query_results = Condo.all.select { |condo| condo.name.downcase.include?(@query) } unless @query.empty?
    recent_admins
    first_condos
    render 'index'
  end

  def find_tenant
    tenant_document_number = params[:get_tenant_bill]
    @tenant = Tenant.find(document_number: tenant_document_number)
    render :index, locals: { tenant: @tenant, bills: find_bills }
  end

  def tenant_bill
    @tenant = Tenant.find(document_number: params[:tenant_document_number])
    find_bill(params[:bill_id])
  end

  def choose_profile; end

  private

  def recent_admins
    @admins = Admin.all
    @admins = @admins.where.not(id: current_admin.id) if current_admin
    @recent_admins = @admins.order(created_at: :desc).limit(3) if admin_signed_in?
  end

  def first_condos
    return unless admin_signed_in?

    if current_admin.super_admin?
      @condos = Condo.all.sort_by(&:name)
    else
      condo_ids = current_admin.associated_condos.map(&:condo_id)
      @condos = Condo.all.select { |condo| condo_ids.include?(condo.id) }
    end

    @first_condos = @condos.sort_by(&:name).take(4)
  end

  def first_units
    @units = Unit.find_all_by_owner(current_property_owner.document_number)
    @first_units = @units.take(4)
  end

  def find_bills
    @bills = Bill.where(unit_id: @tenant.residence['id'])
  end

  def find_bill(bill_id)
    @bill = Bill.find(bill_id)
  end
end
