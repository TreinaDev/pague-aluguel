require 'rails_helper'

RSpec.describe BaseFee, type: :model do
  describe '#valid?' do
    context 'presence' do
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
        expect(base_fee.errors[:charge_day]).to include('deve ser futura.')
      end
    end

    context 'numericality' do
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

    context 'installments' do
      it 'deve ficar em branco para taxas fixas' do
        base_fee = build(:base_fee, limited: false, installments: 10)

        expect(base_fee).not_to be_valid
        expect(base_fee.errors).to include(:installments)
        expect(base_fee.errors[:installments]).to include('não se aplica a Taxas Fixas.')
      end

      it 'não pode ficar em branco para taxas limitadas' do
        base_fee = build(:base_fee, limited: true, installments: '')

        expect(base_fee).not_to be_valid
        expect(base_fee.errors).to include(:installments)
        expect(base_fee.errors[:installments]).to include('deve estar presente para Taxas Limitadas.')
      end

      it 'deve ser maior que 0' do
        base_fee = build(:base_fee, limited: true, installments: -10)

        expect(base_fee).not_to be_valid
        expect(base_fee.errors).to include(:installments)
        expect(base_fee.errors[:installments]).to include('deve ser maior que 0')
      end

      it 'deve ser um número' do
        base_fee = build(:base_fee, limited: true, installments: 'Dez parcelas')

        expect(base_fee).not_to be_valid
        expect(base_fee.errors).to include(:installments)
        expect(base_fee.errors[:installments]).to include('não é um número')
      end
    end
  end

  describe '#value_builder' do
    it 'cria value para cada unit_type' do
      condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [])
      unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quarto', metreage: 200, fraction: 2.0,
                                 unit_ids: [])
      unit_types << UnitType.new(id: 3, description: 'Apartamento 3 quarto', metreage: 300, fraction: 3.0,
                                 unit_ids: [])
      base_fee = create(:base_fee, condo_id: 1)
      allow(Condo).to receive(:find).and_return(condo)
      allow(UnitType).to receive(:all).and_return(unit_types)

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
