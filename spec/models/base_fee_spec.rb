require 'rails_helper'

RSpec.describe BaseFee, type: :model do
  describe 'válido?' do
    context 'presença' do
      it 'valida presença' do
        base_fee = build(:base_fee, name: '', description: '', interest_rate: '', late_fine: '', charge_day: '')

        expect(base_fee).not_to be_valid
        expect(base_fee.errors).to include(:name)
        expect(base_fee.errors).to include(:description)
        expect(base_fee.errors).to include(:interest_rate)
        expect(base_fee.errors).to include(:late_fine)
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

    context 'numericalidade' do
      it 'multa deve ser um número' do
        base_fee = build(:base_fee, late_fine: 'multinha')

        expect(base_fee).not_to be_valid
        expect(base_fee.errors).to include(:late_fine)
        expect(base_fee.errors[:late_fine]).to include('não é um número')
      end

      it 'multa não deve ser negativa' do
        base_fee = build(:base_fee, late_fine: -10)

        expect(base_fee).not_to be_valid
        expect(base_fee.errors).to include(:late_fine)
        expect(base_fee.errors[:late_fine]).to include('deve ser maior ou igual a 0')
      end

      it 'multa pode ser igual a zero' do
        base_fee = build(:base_fee, late_fine: 0)

        expect(base_fee).to be_valid
        expect(base_fee.errors).not_to include(:late_fine)
        expect(base_fee.errors[:late_fine]).not_to include('deve ser maior ou igual a 0')
      end

      it 'juros ao dia pode ser igual a zero' do
        base_fee = build(:base_fee, interest_rate: 0)

        expect(base_fee).to be_valid
        expect(base_fee.errors).not_to include(:interest_rate)
        expect(base_fee.errors[:interest_rate]).not_to include('deve ser maior ou igual a 0')
      end
    end
  end

  describe '#value_builder' do
    it 'cria value para cada unit_type' do
      condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 222.2,
                                 condo_id: 1)
      unit_types << UnitType.new(id: 2, area: 45, description: 'Apartamento 2 quartos', ideal_fraction: 222.2,
                                 condo_id: 1)
      unit_types << UnitType.new(id: 3, area: 60, description: 'Apartamento 3 quartos', ideal_fraction: 222.2,
                                 condo_id: 1)
      base_fee = create(:base_fee, condo_id: 1)
      allow(Condo).to receive(:find).and_return(condo)
      allow(UnitType).to receive(:find_all_by_condo).and_return(unit_types)

      values = base_fee.value_builder

      values[0].price_cents = 100_00
      values[1].price_cents = 200_00
      values[2].price_cents = 300_00

      base_fee.save!

      expect(values.size).to eq(3)
      expect(values[0].unit_type_id).to eq unit_types[0].id
      expect(values[1].unit_type_id).to eq unit_types[1].id
      expect(values[2].unit_type_id).to eq unit_types[2].id
      expect(values[0].price_cents).to eq 100_00
      expect(values[1].price_cents).to eq 200_00
      expect(values[2].price_cents).to eq 300_00
    end
  end
end
