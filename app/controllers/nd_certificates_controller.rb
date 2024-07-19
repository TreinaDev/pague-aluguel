class NdCertificatesController < ApplicationController
  before_action :set_condo, only: [:index]

  def index
    @units = Unit.all(params[:condo_id])
  end

  def show
    @unit = Unit.find(params[:id])
  end

  private

  def set_condo
    @condo = Condo.find(params[:condo_id])
  end
end
