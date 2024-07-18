require 'rails_helper'

describe BillCalculator do
  context '.calculate_total_fees' do
    it 'e retorna valor total da fatura' do
      cpf = CPF.generate
      allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
      create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                              document_number: cpf)
      condos = []
      condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      shared_fee = create(:shared_fee, description: 'Descrição', issue_date: Time.zone.today,
                                       total_value: 30_000_00, condo_id: condos.first.id)
      create(:shared_fee_fraction, shared_fee:, unit_id: 1, value_cents: 300_00)
      base_fee = create(:base_fee, condo_id: condos.first.id, charge_day: Time.zone.today)
      create(:value, price_cents: 100_00, base_fee_id: base_fee.id)
      create(:rent_fee, owner_id: 1, tenant_id: 1, unit_id: 1, value_cents: 120_000,
                        issue_date: 1.day.from_now, fine_cents: 5000, fine_interest: 10, condo_id: 1)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:all).and_return(units)
      SingleCharge.create!(charge_type: :fine, value_cents: 100_11, description: 'Multa por barulho',
                           issue_date: 1.day.from_now, unit_id: units.first.id, condo_id: condos.first.id)

      travel_to 1.month.from_now do
        fees = BillCalculator.calculate_total_fees(units.first)

        expect(fees).to eq 170_011
      end
    end

    it 'e retorna zero caso nao tenha taxas' do
      condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      allow(Condo).to receive(:find).and_return(condo)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:all).and_return(units)

      travel_to 1.month.from_now do
        fees = BillCalculator.calculate_total_fees(units.first)

        expect(fees).to eq 0
      end
    end
  end

  context '.calculate_shared_fees' do
    it 'e retorna valores de taxas compartilhadas da fatura' do
      condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
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
        fees = BillCalculator.calculate_shared_fees(unit_types.first)

        expect(fees).to eq 300_00
      end
    end

    it 'nao possui taxas compatilhadas' do
      condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      allow(Condo).to receive(:find).and_return(condo)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:all).and_return(units)

      travel_to 1.month.from_now do
        fees = BillCalculator.calculate_shared_fees(unit_types.first)

        expect(fees).to eq 0
      end
    end
  end

  context '.calculate_single_charges' do
    it 'e retorna valores de cobranças avulsas da fatura' do
      condos = []
      condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
      units << Unit.new(id: 2, area: 40, floor: 1, number: 2, unit_type_id: 1)
      common_areas = []
      common_areas << CommonArea.new(id: 1, name: 'Academia',
                                     description: 'Uma academia raíz com ventilador apenas para os marombas',
                                     max_occupancy: 20, rules: 'Não pode ser frango', condo_id: 1)
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(CommonArea).to receive(:all).and_return(common_areas)
      SingleCharge.create!(charge_type: :fine, value_cents: 100_11, description: 'Multa por barulho',
                           issue_date: 5.days.from_now.to_date, unit_id: units.first.id, condo_id: condos.first.id)

      travel_to 1.month.from_now do
        fees = BillCalculator.calculate_single_charges(unit_types.first)

        expect(fees).to eq 100_11
      end
    end

    it 'nao possui cobranças avulsas' do
      condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      allow(Condo).to receive(:find).and_return(condo)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:all).and_return(units)

      travel_to 1.month.from_now do
        fees = BillCalculator.calculate_single_charges(unit_types.first)

        expect(fees).to eq 0
      end
    end
  end

  context 'ignora taxas, contas e cobranças canceladas' do
    it 'com sucesso' do
      condos = []
      condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      unit_types = []
      unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.1,
                                 condo_id: condos.first.id)
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      shared_fee_canceled = create(:shared_fee, description: 'Descrição', issue_date: Time.zone.now,
                                                total_value: 30_000_000_00, condo_id: condos.first.id)
      create(:shared_fee_fraction, shared_fee: shared_fee_canceled, unit_id: 1, value_cents: 30_000_00)
      shared_fee_canceled.canceled!
      shared_fee = create(:shared_fee, description: 'Descrição', issue_date: Time.zone.now,
                                       total_value: 30_000_00, condo_id: condos.first.id)
      create(:shared_fee_fraction, shared_fee:, unit_id: 1, value_cents: 300_00)
      base_fee = create(:base_fee, condo_id: condos.first.id)
      create(:value, price_cents: 100_00, base_fee_id: base_fee.id)
      base_fee_canceled = create(:base_fee, condo_id: condos.first.id)
      create(:value, price_cents: 333_00, base_fee_id: base_fee_canceled.id)
      base_fee_canceled.canceled!
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(CommonArea).to receive(:all).and_return([])
      SingleCharge.create!(charge_type: :fine, value_cents: 100_11, description: 'Multa por barulho',
                           issue_date: Time.zone.now, unit_id: units.first.id, condo_id: condos.first.id)
      single_charge_canceled = SingleCharge.create!(charge_type: :fine, value_cents: 555_55,
                                                    description: 'Multa por barulho',
                                                    issue_date: Time.zone.now, unit_id: units.first.id,
                                                    condo_id: condos.first.id)
      single_charge_canceled.canceled!

      travel_to 1.month.from_now do
        fees = BillCalculator.calculate_total_fees(units.first)

        expect(fees).to eq 500_11
      end
    end
  end
end
