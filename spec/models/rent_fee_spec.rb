require 'rails_helper'

RSpec.describe RentFee, type: :model do
  it { should validate_presence_of(:condo_id) }
  it { should validate_presence_of(:tenant_id) }
  it { should validate_presence_of(:owner_id) }
  it { should validate_presence_of(:unit_id) }
  it { should validate_presence_of(:value_cents) }
  it { should validate_presence_of(:issue_date) }
  it { should validate_presence_of(:fine_cents) }
  it { should validate_presence_of(:fine_interest) }
  it { should validate_numericality_of(:value).is_greater_than(0) }
  it { should validate_numericality_of(:fine).is_greater_than_or_equal_to(0) }

  context '#valid?' do
    it 'invalido se a data não é futura' do
      rent_fee = RentFee.new(issue_date: 1.day.ago)

      rent_fee.valid?
      result = rent_fee.errors.include?(:issue_date)

      expect(result).to be_truthy
      expect(rent_fee.errors[:issue_date]).to include 'deve ser futura.'
    end
  end
end
