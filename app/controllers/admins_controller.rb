class AdminsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @admins = Admin.where.not(id: current_admin.id) if current_admin
    @recent_admins = @admins.order(created_at: :desc).limit(3)
    @admins = @admins.where.not(id: @recent_admins.pluck(:id)).order(first_name: :asc)
    @admins = @admins.where.not(id: current_admin.id) if current_admin
  end

  def condos_selection
    @admin = Admin.find(params[:id])
    @condos = Condo.all
    @present_associations = @admin.associated_condos.select { |ac| ac.condo_id.present? }
  end

  def condos_selection_post
    admin = Admin.find(params[:id])
    admin.associated_condos.destroy_all
    params[:condo_ids].each do |condo_id|
      admin.associated_condos.create(condo_id: condo_id)
    end
    redirect_to root_path, notice: 'Acesso aos condomínios atualizado com sucesso'
  end
end
