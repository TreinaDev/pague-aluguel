class CondosController < ApplicationController
  def show
    @condo = Condo.find(params[:id])
    @base_fees = @condo.base_fees
  end
end