class UnitsController < ApplicationController
  before_action :verify_ownership
  # before_action :set_unit

  def show
    @unit = Unit.find(params[:id])
  end

  private

  def set_unit
    @unit = Unit.find(params[:id])
    return unless @unit.nil? || @unit.id.nil?

    redirect_to(root_url, alert: 'Unidade não encontrada.')
  end

  def verify_ownership
    return if @unit.nil?

    owner_units = Unit.find_all_by_owner(current_property_owner.document_number)
    return if owner_units.any? { |unit| unit.id == @unit.id }

    redirect_to(root_url, alert: 'Você não tem permissão para acessar essa página')
  end
end
