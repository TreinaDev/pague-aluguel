class HomeController < ApplicationController

  def index
    @admins = Admin.all
    @admins = @admins.where.not(id: current_admin.id) if current_admin
    @recent_admins = @admins.order(created_at: :desc).limit(3)
    @condos = Condo.all.sort_by { |condo| condo.name }
    @recent_condos = @condos.take(4)
  end

end
