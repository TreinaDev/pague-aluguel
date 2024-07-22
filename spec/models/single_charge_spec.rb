require 'rails_helper'

RSpec.describe SingleCharge, type: :model do
  describe '#valid?' do
    it ':unit_id, :issue_date, presence: true' do
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:all).and_return(units)
      single_charge = build(:single_charge, charge_type: 'fine', unit_id: '', issue_date: '', value: '')

      single_charge.valid?

      expect(single_charge.errors.include?(:unit_id)).to be true
      expect(single_charge.errors.full_messages).to include 'Unidade não pode ficar em branco'
      expect(single_charge.errors.include?(:issue_date)).to be true
      expect(single_charge.errors.full_messages).to include 'Data de Emissão não pode ficar em branco'
      expect(single_charge.errors.include?(:value)).to be true
      expect(single_charge.errors.full_messages).to include 'Valor Total não é um número'
    end

    it ':value, numericality' do
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)
      single_charge = build(:single_charge, charge_type: 'fine', value: -1)

      single_charge.valid?

      expect(single_charge.errors.include?(:value)).to be true
      expect(single_charge.errors.full_messages).to include 'Valor Total deve ser maior que 0'
    end

    it 'common_area_is_mandatory' do
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)
      single_charge = build(:single_charge, charge_type: 'common_area_fee', common_area_id: '')

      single_charge.valid?

      expect(single_charge.errors.include?(:common_area_id)).to be true
      expect(single_charge.errors.full_messages).to include 'Área Comum deve ser selecionada.'
    end

    it 'date_is_future' do
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)
      single_charge = build(:single_charge, issue_date: 5.days.ago.to_date)

      single_charge.valid?

      expect(single_charge.errors.include?(:issue_date)).to be true
      expect(single_charge.errors.full_messages).to include 'Data de Emissão deve ser a partir de hoje.'
    end

    it 'description_is_mandatory' do
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)
      single_charge = build(:single_charge, charge_type: 'other', description: '')
      single_charge_two = build(:single_charge, charge_type: 'fine', description: '')
      single_charge_three = build(:single_charge, charge_type: 'common_area_fee', description: '')

      single_charge.valid?
      single_charge_two.valid?
      single_charge_three.valid?

      expect(single_charge.errors.include?(:description)).to be true
      expect(single_charge.errors.full_messages).to include 'Descrição não pode ficar em branco'
      expect(single_charge_two.errors.include?(:description)).to be true
      expect(single_charge_two.errors.full_messages).to include 'Descrição não pode ficar em branco'
      expect(single_charge_three.errors.include?(:description)).to be false
      expect(single_charge_three.errors.full_messages).not_to include 'Descrição não pode ficar em branco'
    end

    it 'common_area_restriction' do
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)
      create(:single_charge, charge_type: 'fine', common_area_id: 1)

      expect(SingleCharge.first).to be_valid
      expect(SingleCharge.first.charge_type).to eq 'fine'
      expect(SingleCharge.first.common_area_id).to be_nil
    end
  end
end
