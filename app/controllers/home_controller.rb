class HomeController < ApplicationController
  before_action :authenticate_admin!, only: [:search]

  def index
    recent_admins
    first_condos
  end

  def search
    @query = params[:query].downcase
    if current_admin.super_admin?
      @query_results = Condo.all.select { |condo| condo.name.downcase.include?(@query) } unless @query.empty?
    else
      condo_ids = current_admin.associated_condos.map(&:condo_id)
      @condos = Condo.all.select { |condo| condo_ids.include?(condo.id) }
      @query_results = @condos.select { |condo| condo.name.downcase.include?(@query) } unless @query.empty?
    end
    recent_admins
    first_condos
    render 'index'
  end

  def choose_profile; end

  private

  def recent_admins
    @admins = Admin.all
    @admins = @admins.where.not(id: current_admin.id) if current_admin
    if admin_signed_in?
      @recent_admins = @admins.order(created_at: :desc).limit(3)
    end
  end

  def first_condos
    if admin_signed_in?
      if current_admin.super_admin?
        @condos = Condo.all.sort_by(&:name)
      else
        condo_ids = current_admin.associated_condos.map(&:condo_id)
        @condos = Condo.all.select { |condo| condo_ids.include?(condo.id) }
      end
      @first_condos = @condos.sort_by(&:name).take(4)
    end
  end
end
