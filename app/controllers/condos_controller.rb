class CondosController < ApplicationController
  before_action :authenticate_admin!

  def index
    @condos = Condo.all
  end

  def show
    @condo = Condo.find(params[:id])
  end

  def search
    @query = params[:query].downcase
    @condos = Condo.all.select { |condo| condo.name.downcase.include?(@query) }
    render 'index'
  end
end
