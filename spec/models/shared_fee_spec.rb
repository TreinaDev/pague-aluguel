require 'rails_helper'

RSpec.describe SharedFee, type: :model do
  describe 'valid?' do
    context 'presence' do
      it 'false when any field is empty is empty' do
        Condo.create!(name: 'Condo Test', city: 'City Test')
        shared_fee = SharedFee.create(description: '', issue_date: nil,
                                      total_value_cents: '', condo: nil)

        expect(shared_fee.errors.include?(:description)).to be true
        expect(shared_fee.errors.include?(:issue_date)).to be true
        expect(shared_fee.errors.include?(:total_value_cents)).to be true
        expect(shared_fee.errors.include?(:condo)).to be true
      end

      it 'false when total_value_cents is 0' do
        condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                      total_value_cents: 0, condo: condominium)

        expect(shared_fee.errors.include?(:total_value)).to be true
      end

      it 'true when all fields are filled' do
        condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                      total_value_cents: 10_000_00, condo: condominium)

        expect(shared_fee.errors.include?(:description)).to be false
        expect(shared_fee.errors.include?(:issue_date)).to be false
        expect(shared_fee.errors.include?(:total_value_cents)).to be false
        expect(shared_fee.errors.include?(:condo)).to be false
      end
    end

    context 'date' do
      it 'false when date is in the past' do
        condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.ago.to_date,
                                      total_value_cents: 10_000_00, condo: condominium)

        expect(shared_fee.errors.full_messages).to include('Data de Emissão deve ser a partir de hoje.')
      end

      it 'true when date is in the future' do
        condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                      total_value_cents: 10_000_00, condo: condominium)

        expect(shared_fee.errors.include?(:issue_date)).to be false
      end

      it 'true when date is today' do
        condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: Time.zone.today,
                                      total_value_cents: 10_000_00, condo: condominium)

        expect(shared_fee.errors.include?(:issue_date)).to be false
      end
    end

    it { should belong_to(:condo) }
    it { should have_many(:shared_fee_fractions) }
  end
end
