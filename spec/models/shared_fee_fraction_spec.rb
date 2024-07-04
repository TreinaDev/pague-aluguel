require 'rails_helper'

RSpec.describe SharedFeeFraction, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:value_cents) }
    it { should belong_to(:shared_fee) }
    it { should validate_numericality_of(:value).is_greater_than(0) }

    context 'presence' do
      it 'falso quando value_cents é vazio' do
        condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')

        shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                      total_value_cents: 10_000_00, condo_id: condo.id)
        shared_fee_fraction = SharedFeeFraction.create(shared_fee:, unit_id: 1, value_cents: '')

        expect(shared_fee_fraction.errors.include?(:value_cents)).to be true
      end
    end
  end
end
