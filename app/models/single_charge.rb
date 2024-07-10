class SingleCharge < ApplicationRecord
  validates :unit_id, :issue_date, presence: true
  validate :common_area_is_mandatory
  validate :date_is_future
  validate :description_is_mandatory

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

  def common_area_is_mandatory
    return unless charge_type == 'common_area_fee' && common_area_id.nil?

    errors.add(:common_area_id, 'deve ser selecionada.')
  end

  def date_is_future
    return unless issue_date.present? && issue_date < Time.zone.today

    errors.add(:issue_date, 'deve ser a partir de hoje.')
  end

  def description_is_mandatory
    return unless charge_type != 'common_area_fee' && description.nil?

    errors.add(:description, 'não pode ficar em branco.')
  end
end
