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

  describe '#value_builder' do
    it 'cria value para cada unit_type' do
      condo = create(:condo, name: 'Condo Test', city: 'City Test')
      unit_type1 = create(:unit_type, description: 'Apartamento 1 quarto', condo:)
      unit_type2 = create(:unit_type, description: 'Apartamento 2 quartos', condo:)
      unit_type3 = create(:unit_type, description: 'Apartamento 3 quartos', condo:)
      base_fee = create(:base_fee, condo: )

      values = base_fee.value_builder

      values[0].price_cents = 100_00
      values[1].price_cents = 200_00
      values[2].price_cents = 300_00

      base_fee.save!

      expect(values.size).to eq(3)
      expect(values[0].unit_type).to eq unit_type1
      expect(values[1].unit_type).to eq unit_type2
      expect(values[2].unit_type).to eq unit_type3
      expect(values[0].price_cents).to eq 100_00
      expect(values[1].price_cents).to eq 200_00
      expect(values[2].price_cents).to eq 300_00
    end
  end
end
