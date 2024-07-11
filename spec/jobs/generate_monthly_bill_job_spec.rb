require 'rails_helper'

RSpec.describe GenerateMonthlyBillJob, type: :job do
  context 'gera faturas automaticamente' do
    it 'e envia fatura mensal pra um condominio' do
      condos = []
      condos << Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.1,
                                 condo_id: 1)
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      shared_fee = create(:shared_fee, description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                       total_value: 30_000_00, condo_id: condos.first.id)
      create(:shared_fee_fraction, shared_fee:, unit_id: 1, value_cents: 300_00)
      base_fee = create(:base_fee, condo_id: 1)
      create(:value, price_cents: 100_00, base_fee_id: base_fee.id)
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:find_all_by_condo).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:find_all_by_condo).and_return(units)

      travel_to 35.days.from_now do
        units.each do |unit|
          GenerateMonthlyBillJob.perform_now(unit)
        end

        expect(Bill.count).to eq 1
        expect(Bill.last.issue_date).to eq Time.zone.today.beginning_of_month
        expect(Bill.last.due_date).to eq Time.zone.today.beginning_of_month + 9.days
        expect(Bill.last.total_value_cents).to eq 400_00
      end
    end

    it 'e envia fatura mensal para vários condomínios' do
      condos = []
      condos << Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      condos << Condo.new(id: 2, name: 'Outro prédio', city: 'Cidade legalzinha')
      first_unit_types = []
      first_unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.1,
                                       condo_id: 1)
      second_unit_types = []
      second_unit_types << UnitType.new(id: 2, area: 60, description: 'Apartamento 2 quartos',
                                        ideal_fraction: 0.2,
                                        condo_id: 2)
      first_units = []
      second_units = []
      first_units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      first_units << Unit.new(id: 2, area: 200, floor: 2, number: 2, unit_type_id: 1)
      second_units << Unit.new(id: 3, area: 300, floor: 3, number: 3, unit_type_id: 2)
      second_units << Unit.new(id: 4, area: 400, floor: 4, number: 4, unit_type_id: 2)
      first_shared_fee = create(:shared_fee, description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                                             total_value: 30_000_00, condo_id: condos.first.id)
      second_shared_fee = create(:shared_fee, description: 'Conta de Agua', issue_date: 5.days.from_now.to_date,
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
      allow(UnitType).to receive(:find_all_by_condo).and_return(first_unit_types, second_unit_types)
      allow(Unit).to receive(:find).and_return(first_units.first, first_units.last, second_units.first,
                                               second_units.last)
      allow(Unit).to receive(:find_all_by_condo).and_return(first_units, second_units)

      travel_to 35.days.from_now do
        first_units.each do |unit|
          GenerateMonthlyBillJob.perform_now(unit)
        end
        second_units.each do |unit|
          GenerateMonthlyBillJob.perform_now(unit)
        end

        expect(Bill.count).to eq 4
        expect(Bill.last.issue_date).to eq Time.zone.today.beginning_of_month
        expect(Bill.last.due_date).to eq Time.zone.today.beginning_of_month + 9.days
        expect(Bill.find(1).total_value_cents).to eq 211_00
        expect(Bill.find(2).total_value_cents).to eq 322_00
        expect(Bill.find(3).total_value_cents).to eq 533_00
        expect(Bill.find(4).total_value_cents).to eq 644_00
      end
    end

    it 'e apenas retorna taxas condominiais referentes ao mês atual' do
      condos = []
      condos << Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.1,
                                 condo_id: 1)
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      shared_fee = create(:shared_fee, description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                       total_value: 30_000_00, condo_id: condos.first.id)
      create(:shared_fee_fraction, shared_fee:, unit_id: 1, value_cents: 300_00)
      first_base_fee = create(:base_fee, condo_id: 1, recurrence: :monthly, charge_day: 10.days.from_now)
      second_base_fee = create(:base_fee, condo_id: 1, recurrence: :biweekly, charge_day: 2.days.from_now)
      third_base_fee = create(:base_fee, condo_id: 1, recurrence: :monthly, charge_day: 45.days.from_now)
      create(:value, price_cents: 100_00, base_fee_id: first_base_fee.id)
      create(:value, price_cents: 200_00, base_fee_id: second_base_fee.id)
      create(:value, price_cents: 90_00, base_fee_id: third_base_fee.id)
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:find_all_by_condo).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:find_all_by_condo).and_return(units)

      travel_to 35.days.from_now do
        units.each do |unit|
          GenerateMonthlyBillJob.perform_now(unit)
        end

        expect(Bill.count).to eq 1
        expect(Bill.first.issue_date).to eq Time.zone.today.beginning_of_month
        expect(Bill.first.due_date).to eq Time.zone.today.beginning_of_month + 9.days
        expect(Bill.first.total_value_cents).to eq 800_00
      end
    end

    it 'e apenas retorna taxas compartilhadas referentes ao mês atual' do
      condos = []
      condos << Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.1,
                                 condo_id: 1)
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      first_shared_fee = create(:shared_fee, description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                             total_value: 20_000_00, condo_id: condos.first.id)
      second_shared_fee = create(:shared_fee, description: 'Descrição', issue_date: 45.days.from_now.to_date,
                                              total_value: 13_000_00, condo_id: condos.first.id)
      create(:shared_fee_fraction, shared_fee: first_shared_fee, unit_id: 1, value_cents: 200_00)
      create(:shared_fee_fraction, shared_fee: second_shared_fee, unit_id: 1, value_cents: 130_00)
      first_base_fee = create(:base_fee, condo_id: 1, recurrence: :monthly, charge_day: 10.days.from_now)
      second_base_fee = create(:base_fee, condo_id: 1, recurrence: :monthly, charge_day: 45.days.from_now)
      create(:value, price_cents: 150_00, base_fee_id: first_base_fee.id)
      create(:value, price_cents: 111_11, base_fee_id: second_base_fee.id)
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:find_all_by_condo).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:find_all_by_condo).and_return(units)

      travel_to 65.days.from_now do
        units.each do |unit|
          GenerateMonthlyBillJob.perform_now(unit)
        end

        expect(Bill.count).to eq 1
        expect(Bill.first.issue_date).to eq Time.zone.today.beginning_of_month
        expect(Bill.first.due_date).to eq Time.zone.today.beginning_of_month + 9.days
        expect(Bill.first.total_value_cents).to eq 241_11
      end
    end
  end
end
