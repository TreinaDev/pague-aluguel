class CondosController < ApplicationController
  before_action :authenticate_admin!

  def index
    @condos = Condo.all
    @recent_condos = @condos.sort_by { |condo| condo.name }.take(4)
    @condos = @condos.excluding(@recent_condos)
  end

  def show
    @condo = Condo.find(params[:id])
  end
end
