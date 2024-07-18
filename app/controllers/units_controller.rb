class UnitsController < ApplicationController
  before_action :set_unit, only: [:show]
  before_action :verify_ownership, only: [:show]

  def index
    @units = Unit.find_all_by_owner(current_property_owner.document_number)
  end

  def show; end

  private

  def set_unit
    @unit = Unit.find(params[:id])
  end

  def verify_ownership
    return if @unit.nil?

    owner_units = Unit.find_all_by_owner(current_property_owner.document_number)
    return if owner_units.any? { |unit| unit.id == @unit.id }

    redirect_to(root_url, alert: I18n.t('views.show.not_allowed'))
  end
end
