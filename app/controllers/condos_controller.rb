class CondosController < ApplicationController
  before_action :authenticate_admin!

  def index
    @condos = Condo.all
  end

  def show
    @condo = Condo.find(params[:id])
  end
end
