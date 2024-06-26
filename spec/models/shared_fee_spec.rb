require 'rails_helper'

RSpec.describe SharedFee, type: :model do
  describe 'valid?' do
    context 'presence' do
      it 'false when description is empty' do
        condominio = Condo.create!(name: 'Condo Test', city: 'City Test')
        shared_fee = SharedFee.create(description: '', issue_date: 10.days.from_now.to_date,
                                      total_value: 1000, condo: condominio)

        expect(shared_fee.errors.include?(:description)).to be true
      end

      it 'false when issue date is empty' do
        condominio = Condo.create!(name: 'Condo Test', city: 'City Test')
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: '',
                                      total_value: 1000, condo: condominio)

        expect(shared_fee.errors.include?(:issue_date)).to be true
      end

      it 'false when total value is empty' do
        condominio = Condo.create!(name: 'Condo Test', city: 'City Test')
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                      total_value: '', condo: condominio)

        expect(shared_fee.errors.include?(:total_value)).to be true
      end

      it 'false when there is no condo' do
        shared_fee = SharedFee.create(description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                      total_value: 1000)

        expect(shared_fee.errors.include?(:condo)).to be true
      end
    end
  end
end
