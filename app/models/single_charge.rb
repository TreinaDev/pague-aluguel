class SingleCharge < ApplicationRecord
  validates :unit_id, :issue_date, presence: true
  validate :common_area_is_mandatory
  validate :date_is_future
  validate :description_is_mandatory
  validate :unit_belongs_to_condo

  before_create :common_area_restriction

  enum status: {
    active: 0,
    canceled: 5
  }

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

    errors.add(:common_area_id, I18n.t('errors.must_be.selected'))
  end

  def date_is_future
    return unless issue_date.present? && issue_date.past?

    errors.add(:issue_date, I18n.t('errors.must_be.after_today'))
  end

  def description_is_mandatory
    return unless !common_area_fee? && description.blank?

    errors.add(:description, I18n.t('errors.cant_be.blank'))
  end

  def unit_belongs_to_condo
    return if unit_id.blank? || condo_id.blank?

    units = Unit.all(condo_id)

    return if units.nil?

    return if units.any? { |unit| unit.id == unit_id }

    errors.add(:unit_id, I18n.t('errors.must_have.associated_condo'))
  end
end
