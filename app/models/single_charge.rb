class SingleCharge < ApplicationRecord
  validates :unit_id, :issue_date, presence: true
  validate :common_area_is_mandatory
  validate :date_is_future
  validate :description_is_mandatory
  validate :unit_belongs_to_condo

  before_create :common_area_restriction

  monetize :value_cents,
           allow_nil: false,
           numericality: {
             greater_than: 0
           }

  enum charge_type: {
    fine: 0,
    common_area_fee: 2,
    other: 5
  }

  private

  def common_area_restriction
    self.common_area_id = nil unless common_area_fee?
  end

  def common_area_is_mandatory
    return unless common_area_fee? && common_area_id.blank?

    errors.add(:common_area_id, 'deve ser selecionada')
  end

  def date_is_future
    return unless issue_date.present? && issue_date.past?

    errors.add(:issue_date, 'deve ser a partir de hoje')
  end

  def description_is_mandatory
    return unless !common_area_fee? && description.blank?

    errors.add(:description, 'não pode ficar em branco')
  end

  def unit_belongs_to_condo
    return if unit_id.blank?

    unit = Unit.find(unit_id)
    return if condo_id == UnitType.find(unit.unit_type_id).condo_id

    errors.add(:unit_id, 'deve pertencer ao condomínio')
  end
end