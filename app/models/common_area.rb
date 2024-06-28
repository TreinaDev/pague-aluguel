class CommonArea < ApplicationRecord
  belongs_to :condo
  validate :fee_not_negative, on: :update
  validates :fee_cents, numericality: { only_integer: true }

  has_many :common_area_fee_histories, dependent: :destroy

  after_update :add_fee_to_history

  monetize :fee_cents

  private

  def fee_not_negative
    errors.add(:fee_cents, ' não pode ser negativa.') if fee_cents.negative?
  end

  def add_fee_to_history
    CommonAreaFeeHistory.create!(fee_cents:, common_area: self)
  end
end
