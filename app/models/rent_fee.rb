class RentFee < ApplicationRecord
  validates :condo_id, :tenant_id, :owner_id, :unit_id, :value_cents, :issue_date, :fine_cents, :fine_interest,
            presence: true

  validate :issue_date_is_future, on: :create

  monetize :value_cents,
           allow_nil: false,
           numericality: {
             greater_than: 0
           }

  monetize :fine_cents,
           allow_nil: false,
           numericality: {
             greater_than_or_equal_to: 0
           }

  enum status: {
    active: 0,
    canceled: 5
  }

  private

  def issue_date_is_future
    return if issue_date&.future?

    errors.add(:issue_date, I18n.t('errors.must_be_future'))
  end
end
