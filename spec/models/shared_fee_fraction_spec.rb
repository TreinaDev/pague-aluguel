require 'rails_helper'

RSpec.describe SharedFeeFraction, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:value_cents) }
    it { should belong_to(:shared_fee) }
    it { should belong_to(:unit) }
    it { should validate_numericality_of(:value).is_greater_than(0) }

    context 'presence' do
      it 'false when value_cents is empty' do
        condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
        UnitType.create!(ideal_fraction: 0.04, condo: condominium)
        unit = Unit.create!(area: 100, number: 101, floor: 1, unit_type: UnitType.last)
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                      total_value_cents: 10_000_00, condo: condominium)
        shared_fee_fraction = SharedFeeFraction.create(shared_fee:, unit:, value_cents: '')

        expect(shared_fee_fraction.errors.include?(:value_cents)).to be true
      end
    end
  end
end
