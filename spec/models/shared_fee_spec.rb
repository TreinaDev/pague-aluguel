require 'rails_helper'

RSpec.describe SharedFee, type: :model do
  describe 'valido?' do
    context 'presente' do
      it 'falso quando qualquer campo está vazio' do
        Condo.create!(name: 'Condo Test', city: 'City Test')
        shared_fee = SharedFee.create(description: '', issue_date: nil,
                                      total_value: '', condo: nil)

        expect(shared_fee.errors.include?(:description)).to be true
        expect(shared_fee.errors.include?(:issue_date)).to be true
        expect(shared_fee.errors.include?(:total_value)).to be true
        expect(shared_fee.errors.include?(:condo)).to be true
      end

      it 'falso quando o total_value é 0' do
        condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                      total_value: 0, condo: condominium)

        expect(shared_fee.errors.include?(:total_value)).to be true
      end

      it 'verdadeiro quando tudo está preenchido' do
        condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                      total_value: 10_000, condo: condominium)

        expect(shared_fee.errors.include?(:description)).to be false
        expect(shared_fee.errors.include?(:issue_date)).to be false
        expect(shared_fee.errors.include?(:total_value)).to be false
        expect(shared_fee.errors.include?(:condo)).to be false
      end
    end

    context 'data' do
      it 'falso quando a data está no passado' do
        condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.ago.to_date,
                                      total_value: 10_000, condo: condominium)

        expect(shared_fee.errors.full_messages).to include('Data de Emissão deve ser a partir de hoje.')
      end

      it 'verdadeiro quando a data está no futuro' do
        condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                      total_value: 10_000, condo: condominium)

        expect(shared_fee.errors.include?(:issue_date)).to be false
      end

      it 'verdadeiro quando a data é hoje' do
        condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: Time.zone.today,
                                      total_value: 10_000, condo: condominium)

        expect(shared_fee.errors.include?(:issue_date)).to be false
      end
    end

    it { should belong_to(:condo) }
    it { should have_many(:shared_fee_fractions) }
  end
end
