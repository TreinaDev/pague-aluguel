require 'rails_helper'

RSpec.describe BaseFee, type: :model do
  describe 'válido?' do
    context 'presença' do
      it 'valida presença' do
        base_fee = build(:base_fee, name: '', description: '', late_payment: '',
                                    late_fee: '', charge_day: '')

        expect(base_fee).not_to be_valid
        expect(base_fee.errors).to include(:name)
        expect(base_fee.errors).to include(:description)
        expect(base_fee.errors).to include(:late_payment)
        expect(base_fee.errors).to include(:late_fee)
        expect(base_fee.errors).to include(:charge_day)
      end
    end

    context 'data' do
      it 'data deve ser futura' do
        base_fee = build(:base_fee, charge_day: 1.day.ago)

        expect(base_fee).not_to be_valid
        expect(base_fee.errors).to include(:charge_day)
        expect(base_fee.errors[:charge_day]).to include('deve ser futura')
      end
    end
  end
end
