require 'rails_helper'

RSpec.describe GenerateMonthlyBillJob, type: :job do
  context 'gera faturas automaticamente' do
    it 'e envia fatura mensal pra um condominio' do
      condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      condos = []
      condos << condo
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')

      shared_fee = create(:shared_fee, description: 'Descrição', issue_date: Time.zone.now,
                                       total_value: 30_000_00, condo_id: condos.first.id)
      create(:shared_fee_fraction, shared_fee:, unit_id: 1, value_cents: 300_00)
      base_fee = create(:base_fee, condo_id: 1)
      create(:value, price_cents: 100_00, base_fee_id: base_fee.id)
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:all).and_return(units)

      travel_to 1.month.from_now do
        units.each do |unit|
          GenerateMonthlyBillJob.perform_now(unit, condo.id)
        end

        expect(Bill.count).to eq 1
        expect(Bill.last.issue_date).to eq Time.zone.today.beginning_of_month
        expect(Bill.last.due_date).to eq Time.zone.today.beginning_of_month + 9.days
        expect(Bill.last.base_fee_value_cents).to eq 100_00
        expect(Bill.last.shared_fee_value_cents).to eq 300_00
        expect(Bill.last.total_value_cents).to eq 400_00
      end
    end

    it 'e envia fatura mensal para vários condomínios' do
      condos = []
      condos << Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      condos << Condo.new(id: 2, name: 'Outro prédio', city: 'Cidade legalzinha')
      first_unit_types = []
      first_unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                       unit_ids: [1, 2], condo_id: 1)
      second_unit_types = []
      second_unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quarto', metreage: 200, fraction: 2.0,
                                        unit_ids: [3, 4], condo_id: 2)
      first_units = []
      second_units = []
      first_units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                              condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      first_units << Unit.new(id: 2, area: 200, floor: 2, number: '21', unit_type_id: 1, condo_id: 1,
                              condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 2, description: 'Com varanda')
      second_units << Unit.new(id: 3, area: 300, floor: 3, number: '31', unit_type_id: 2, condo_id: 2,
                               condo_name: 'Outro prédio', tenant_id: 2, owner_id: 3, description: 'Com varanda')
      second_units << Unit.new(id: 4, area: 400, floor: 4, number: '41', unit_type_id: 2, condo_id: 2,
                               condo_name: 'Outro prédio', tenant_id: 2, owner_id: 4, description: 'Com varanda')
      first_shared_fee = create(:shared_fee, description: 'Conta de Luz', issue_date: Time.zone.now,
                                             total_value: 30_000_00, condo_id: condos.first.id)
      second_shared_fee = create(:shared_fee, description: 'Conta de Agua', issue_date: Time.zone.now,
                                              total_value: 25_000_00, condo_id: condos.last.id)
      create(:shared_fee_fraction, shared_fee: first_shared_fee,
                                   unit_id: 1, value_cents: 111_00)
      create(:shared_fee_fraction, shared_fee: first_shared_fee,
                                   unit_id: 2, value_cents: 222_00)
      create(:shared_fee_fraction, shared_fee: second_shared_fee,
                                   unit_id: 3, value_cents: 333_00)
      create(:shared_fee_fraction, shared_fee: second_shared_fee,
                                   unit_id: 4, value_cents: 444_00)

      first_base_fee = create(:base_fee, condo_id: 1)
      second_base_fee = create(:base_fee, condo_id: 2)
      create(:value, price_cents: 100_00, base_fee_id: first_base_fee.id)
      create(:value, price_cents: 200_00, base_fee_id: second_base_fee.id, unit_type_id: 2)

      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first, condos.last)
      allow(UnitType).to receive(:all).and_return(first_unit_types, second_unit_types)
      allow(Unit).to receive(:find).and_return(first_units.first, first_units.last, second_units.first,
                                               second_units.last)
      allow(Unit).to receive(:all).and_return(first_units, second_units)

      travel_to 1.month.from_now do
        first_units.each do |unit|
          condo_id = first_unit_types.first.condo_id
          GenerateMonthlyBillJob.perform_now(unit, condo_id)
        end
        second_units.each do |unit|
          condo_id = second_unit_types.first.condo_id
          GenerateMonthlyBillJob.perform_now(unit, condo_id)
        end

        expect(Bill.count).to eq 4
        expect(Bill.last.issue_date).to eq Time.zone.today.beginning_of_month
        expect(Bill.last.due_date).to eq Time.zone.today.beginning_of_month + 9.days
        expect(Bill.find(1).total_value_cents).to eq 211_00
        expect(Bill.find(1).base_fee_value_cents).to eq 100_00
        expect(Bill.find(1).shared_fee_value_cents).to eq 111_00
        expect(Bill.find(2).total_value_cents).to eq 322_00
        expect(Bill.find(2).base_fee_value_cents).to eq 100_00
        expect(Bill.find(2).shared_fee_value_cents).to eq 222_00
        expect(Bill.find(3).total_value_cents).to eq 533_00
        expect(Bill.find(3).base_fee_value_cents).to eq 200_00
        expect(Bill.find(3).shared_fee_value_cents).to eq 333_00
        expect(Bill.find(4).total_value_cents).to eq 644_00
        expect(Bill.find(4).base_fee_value_cents).to eq 200_00
        expect(Bill.find(4).shared_fee_value_cents).to eq 444_00
      end
    end

    it 'e apenas retorna taxas condominiais referentes ao mês atual' do
      condos = []
      condos << Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1], condo_id: 1)
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      shared_fee = create(:shared_fee, description: 'Descrição', issue_date: Time.zone.now,
                                       total_value: 30_000_00, condo_id: condos.first.id)
      create(:shared_fee_fraction, shared_fee:, unit_id: 1, value_cents: 300_00)
      first_base_fee = create(:base_fee, condo_id: 1, recurrence: :monthly, charge_day: Time.zone.now)
      second_base_fee = create(:base_fee, condo_id: 1, recurrence: :biweekly, charge_day: Time.zone.now)
      third_base_fee = create(:base_fee, condo_id: 1, recurrence: :monthly, charge_day: 2.months.from_now)
      create(:value, price_cents: 100_00, base_fee_id: first_base_fee.id)
      create(:value, price_cents: 200_00, base_fee_id: second_base_fee.id)
      create(:value, price_cents: 90_00, base_fee_id: third_base_fee.id)
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:all).and_return(units)

      travel_to 1.month.from_now do
        units.each do |unit|
          condo_id = unit_types.first.condo_id
          GenerateMonthlyBillJob.perform_now(unit, condo_id)
        end

        expect(Bill.count).to eq 1
        expect(Bill.first.issue_date).to eq Time.zone.today.beginning_of_month
        expect(Bill.first.due_date).to eq Time.zone.today.beginning_of_month + 9.days
        expect(Bill.first.total_value_cents).to eq 800_00
        expect(Bill.first.base_fee_value_cents).to eq 500_00
        expect(Bill.first.shared_fee_value_cents).to eq 300_00
      end
    end

    it 'e apenas retorna taxas compartilhadas referentes ao mês atual' do
      condos = []
      condos << Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1], condo_id: 1)
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      first_shared_fee = create(:shared_fee, description: 'Descrição', issue_date: Time.zone.now,
                                             total_value: 20_000_00, condo_id: condos.first.id)
      second_shared_fee = create(:shared_fee, description: 'Descrição', issue_date: 1.month.from_now,
                                              total_value: 13_000_00, condo_id: condos.first.id)
      create(:shared_fee_fraction, shared_fee: first_shared_fee, unit_id: 1, value_cents: 200_00)
      create(:shared_fee_fraction, shared_fee: second_shared_fee, unit_id: 1, value_cents: 130_00)
      first_base_fee = create(:base_fee, condo_id: 1, recurrence: :yearly, charge_day: Time.zone.now)
      second_base_fee = create(:base_fee, condo_id: 1, recurrence: :monthly, charge_day: 1.month.from_now)
      create(:value, price_cents: 150_00, base_fee_id: first_base_fee.id)
      create(:value, price_cents: 111_11, base_fee_id: second_base_fee.id)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:all).and_return(units)

      travel_to 2.months.from_now do
        units.each do |unit|
          condo_id = unit_types.first.condo_id
          GenerateMonthlyBillJob.perform_now(unit, condo_id)
        end

        expect(Bill.count).to eq 1
        expect(Bill.first.issue_date).to eq Time.zone.today.beginning_of_month
        expect(Bill.first.due_date).to eq Time.zone.today.beginning_of_month + 9.days
        expect(Bill.first.total_value_cents).to eq 241_11
        expect(Bill.first.base_fee_value_cents).to eq 111_11
        expect(Bill.first.shared_fee_value_cents).to eq 130_00
      end
    end

    it 'e retorna os valores de todas as contas fixas mensais' do
      condos = []
      condos << Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      first_base_fee = create(:base_fee, condo_id: 1, recurrence: :monthly, charge_day: Time.zone.now)
      second_base_fee = create(:base_fee, condo_id: 1, recurrence: :monthly, charge_day: 1.month.from_now)
      third_base_fee = create(:base_fee, condo_id: 1, recurrence: :monthly, charge_day: 2.months.from_now)
      create(:value, price_cents: 100_00, base_fee_id: first_base_fee.id)
      create(:value, price_cents: 111_11, base_fee_id: second_base_fee.id)
      create(:value, price_cents: 333_33, base_fee_id: third_base_fee.id)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:all).and_return(units)

      travel_to 5.months.from_now do
        units.each do |unit|
          unit_types.first.condo_id
          GenerateMonthlyBillJob.perform_now(unit, condos.first.id)
        end

        expect(Bill.count).to eq 1
        expect(Bill.first.issue_date).to eq Time.zone.today.beginning_of_month
        expect(Bill.first.due_date).to eq Time.zone.today.beginning_of_month + 9.days
        expect(Bill.first.total_value_cents).to eq 544_44
      end
    end

    it 'e não possui taxas para a fatura atual' do
      condos = []
      condos << Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1], condo_id: 1)
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      first_shared_fee = create(:shared_fee, description: 'Descrição', issue_date: 45.days.from_now.to_date,
                                             total_value: 20_000_00, condo_id: condos.first.id)
      second_shared_fee = create(:shared_fee, description: 'Descrição', issue_date: 50.days.from_now.to_date,
                                              total_value: 13_000_00, condo_id: condos.first.id)
      create(:shared_fee_fraction, shared_fee: first_shared_fee, unit_id: 1, value_cents: 200_00)
      create(:shared_fee_fraction, shared_fee: second_shared_fee, unit_id: 1, value_cents: 130_00)
      first_base_fee = create(:base_fee, condo_id: 1, recurrence: :monthly, charge_day: 30.days.from_now)
      second_base_fee = create(:base_fee, condo_id: 1, recurrence: :monthly, charge_day: 15.days.from_now)
      create(:value, price_cents: 150_00, base_fee_id: first_base_fee.id)
      create(:value, price_cents: 111_11, base_fee_id: second_base_fee.id)
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:all).and_return(units)

      travel_to 10.days.from_now do
        units.each do |unit|
          condo_id = unit_types.first.condo_id
          GenerateMonthlyBillJob.perform_now(unit, condo_id)
        end

        expect(Bill.count).to eq 1
        expect(Bill.first.issue_date).to eq Time.zone.today.beginning_of_month
        expect(Bill.first.due_date).to eq Time.zone.today.beginning_of_month + 9.days
        expect(Bill.first.total_value_cents).to eq 0
        expect(Bill.first.base_fee_value_cents).to eq 0
        expect(Bill.first.shared_fee_value_cents).to eq 0
      end
    end
  end
end
