class CommonArea < ApplicationRecord
  belongs_to :condo
  validate :fee_not_negative, on: :update
  validates :fee, numericality: { only_integer: true }

  has_many :common_area_fee_histories, dependent: :destroy

  after_update :add_fee_to_history

  private

  def fee_not_negative
    errors.add(:fee, ' não pode ser negativa.') if fee.negative?
  end

  def add_fee_to_history
    CommonAreaFeeHistory.create!(fee:, common_area: self)
  end
end
