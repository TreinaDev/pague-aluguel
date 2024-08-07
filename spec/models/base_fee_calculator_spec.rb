require 'rails_helper'

describe BaseFeeCalculator do
  context '.calculate_base_fees' do
    it 'e retorna valores de taxas condominiais da fatura' do
      condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      shared_fee = create(:shared_fee, description: 'Descrição', issue_date: Time.zone.now,
                                       total_value: 30_000_00, condo_id: condo.id)
      create(:shared_fee_fraction, shared_fee:, unit_id: 1, value_cents: 300_00)
      base_fee = create(:base_fee, condo_id: 1, charge_day: Time.zone.now)
      create(:value, price_cents: 100_00, base_fee_id: base_fee.id)
      allow(Condo).to receive(:find).and_return(condo)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:all).and_return(units)

      travel_to 1.month.from_now do
        fees = BaseFeeCalculator.total_value(unit_types.first)

        expect(fees).to eq 100_00
      end
    end

    it 'e nao possui taxas condominiais' do
      condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      allow(Condo).to receive(:find).and_return(condo)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:all).and_return(units)

      travel_to 1.month.from_now do
        fees = BaseFeeCalculator.total_value(unit_types.first)

        expect(fees).to eq 0
      end
    end
  end

  context '.check_recurrence' do
    it 'e confere recorrencia anual e semestral para gerar fatura' do
      condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      base_fee_yearly = create(:base_fee, condo_id: 1, charge_day: Time.zone.today, recurrence: :yearly)
      create(:value, price_cents: 100_33, base_fee_id: base_fee_yearly.id)
      base_fee_semi_annual = create(:base_fee, condo_id: 1, charge_day: Time.zone.today, recurrence: :semi_annual)
      create(:value, price_cents: 100_15, base_fee_id: base_fee_semi_annual.id)
      allow(Condo).to receive(:find).and_return(condo)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:all).and_return(units)

      travel_to 1.month.from_now do
        fees = BaseFeeCalculator.total_value(unit_types.first)

        expect(fees).to eq 200_48
      end

      travel_to 2.months.from_now do
        fees = BaseFeeCalculator.total_value(unit_types.first)

        expect(fees).to eq 0
      end

      travel_to 7.months.from_now do
        fees = BaseFeeCalculator.total_value(unit_types.first)

        expect(fees).to eq 100_15
      end

      travel_to 13.months.from_now do
        fees = BaseFeeCalculator.total_value(unit_types.first)

        expect(fees).to eq 200_48
      end
    end

    it 'e confere recorrencia quinzenal e mensal para gerar fatura' do
      condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      base_fee_biweekly = create(:base_fee, condo_id: 1, charge_day: Time.zone.now, recurrence: :biweekly)
      create(:value, price_cents: 100_33, base_fee_id: base_fee_biweekly.id)
      base_fee_monthly = create(:base_fee, condo_id: 1, charge_day: Time.zone.now, recurrence: :monthly)
      create(:value, price_cents: 50_12, base_fee_id: base_fee_monthly.id)
      allow(Condo).to receive(:find).and_return(condo)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:all).and_return(units)

      travel_to 1.month.from_now do
        fees = BaseFeeCalculator.total_value(unit_types.first)

        expect(fees).to eq 250_78
      end

      travel_to 2.months.from_now do
        fees = BaseFeeCalculator.total_value(unit_types.first)

        expect(fees).to eq 250_78
      end
    end

    it 'e confere recorrencia bimestral para gerar fatura' do
      condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      base_fee_bimonthly = create(:base_fee, condo_id: 1, charge_day: Time.zone.now, recurrence: :bimonthly)
      create(:value, price_cents: 100_33, base_fee_id: base_fee_bimonthly.id)
      allow(Condo).to receive(:find).and_return(condo)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:all).and_return(units)

      travel_to 1.month.from_now do
        fees = BaseFeeCalculator.total_value(unit_types.first)

        expect(fees).to eq 100_33
      end

      travel_to 2.months.from_now do
        fees = BaseFeeCalculator.total_value(unit_types.first)

        expect(fees).to eq 0
      end

      travel_to 3.months.from_now do
        fees = BaseFeeCalculator.total_value(unit_types.first)

        expect(fees).to eq 100_33
      end
    end
  end

  context '.check_limited_fees' do
    it 'retorna valores de uma taxa limitada mensal' do
      condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      base_fee = create(:base_fee, condo_id: 1, charge_day: Time.zone.today, limited: true,
                                   installments: 10, recurrence: :monthly)
      create(:value, price_cents: 100_00, base_fee_id: base_fee.id)
      allow(Condo).to receive(:find).and_return(condo)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:all).and_return(units)

      10.times do |i|
        travel_to Time.zone.today + (i + 1).months do
          fees = BaseFeeCalculator.total_value(unit_types.first)
          expect(fees).to eq 100_00
          expect(BaseFee.find(base_fee.id).counter).to eq i + 1
        end
      end

      travel_to Time.zone.today + 13.months do
        fees = BaseFeeCalculator.total_value(unit_types.first)
        expect(fees).to eq 0
        expect(BaseFee.find(base_fee.id).paid?).to eq true
      end
    end

    it 'retorna valores de uma taxa limitada bimestral' do
      condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      base_fee = create(:base_fee, condo_id: 1, charge_day: Time.zone.today, limited: true,
                                   installments: 10, recurrence: :bimonthly)
      create(:value, price_cents: 100_00, base_fee_id: base_fee.id)
      allow(Condo).to receive(:find).and_return(condo)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:all).and_return(units)

      20.times do |i|
        travel_to Time.zone.today + (i + 1).months do
          fees = BaseFeeCalculator.total_value(unit_types.first)
          expect(fees).to eq 0 if i.odd?
          expect(fees).to eq 100_00 if i.even?
        end
      end

      travel_to Time.zone.today + 13.months do
        fees = BaseFeeCalculator.total_value(unit_types.first)
        expect(fees).to eq 0
      end
    end
  end
end
