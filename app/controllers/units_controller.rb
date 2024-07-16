class UnitsController < ApplicationController
  def show
    @unit = Unit.find(params[:id])
  end
end
