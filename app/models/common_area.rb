class CommonArea < ApplicationRecord
  belongs_to :condo
  validate :fee_not_negative, on: :update
  validates :fee, numericality: { only_integer: true }

  private

  def fee_not_negative
    errors.add(:fee, ' não pode ser negativa.') if fee.negative?
  end
end
