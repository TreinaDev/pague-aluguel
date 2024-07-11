require 'rails_helper'

describe BillCalculator do
  context '.calculate_total_fees' do
    it 'e retorna valor total da fatura' do
      condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.1,
                                 condo_id: 1)
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      shared_fee = create(:shared_fee, description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                       total_value: 30_000_00, condo_id: condo.id)
      create(:shared_fee_fraction, shared_fee:, unit_id: 1, value_cents: 300_00)
      base_fee = create(:base_fee, condo_id: 1)
      create(:value, price_cents: 100_00, base_fee_id: base_fee.id)
      allow(Condo).to receive(:find).and_return(condo)
      allow(UnitType).to receive(:find_all_by_condo).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:find_all_by_condo).and_return(units)

      travel_to 35.days.from_now do
        Bill.new(unit_id: units.first.id, issue_date: Time.zone.today, due_date: Time.zone.today)

        fees = BillCalculator.calculate_total_fees(units.first)

        expect(fees).to eq 400_00
      end
    end
  end

  context '.calculate_base_fees' do
    it 'e retorna valores de taxas condominiais da fatura' do
      condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.1,
                                 condo_id: 1)
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      shared_fee = create(:shared_fee, description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                       total_value: 30_000_00, condo_id: condo.id)
      create(:shared_fee_fraction, shared_fee:, unit_id: 1, value_cents: 300_00)
      base_fee = create(:base_fee, condo_id: 1, charge_day: 10.days.from_now)
      create(:value, price_cents: 100_00, base_fee_id: base_fee.id)
      allow(Condo).to receive(:find).and_return(condo)
      allow(UnitType).to receive(:find_all_by_condo).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:find_all_by_condo).and_return(units)

      travel_to 35.days.from_now do
        Bill.new(unit_id: units.first.id, issue_date: Time.zone.today, due_date: Time.zone.today)

        fees = BillCalculator.calculate_base_fees(unit_types.first)

        expect(fees).to eq 100_00
      end
    end

    context '.calculate_shared_fees' do
      it 'e retorna valores de taxas compartilhadas da fatura' do
        condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
        unit_types = []
        unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.1,
                                   condo_id: 1)
        units = []
        units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
        shared_fee = create(:shared_fee, description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                         total_value: 30_000_00, condo_id: condo.id)
        create(:shared_fee_fraction, shared_fee:, unit_id: 1, value_cents: 300_00)
        base_fee = create(:base_fee, condo_id: 1, charge_day: 10.days.from_now)
        create(:value, price_cents: 100_00, base_fee_id: base_fee.id)
        allow(Condo).to receive(:find).and_return(condo)
        allow(UnitType).to receive(:find_all_by_condo).and_return(unit_types)
        allow(Unit).to receive(:find).and_return(units.first)
        allow(Unit).to receive(:find_all_by_condo).and_return(units)

        travel_to 35.days.from_now do
          Bill.new(unit_id: units.first.id, issue_date: Time.zone.today, due_date: Time.zone.today)

          fees = BillCalculator.calculate_shared_fees(unit_types.first)

          expect(fees).to eq 300_00
        end
      end
    end
  end
end
