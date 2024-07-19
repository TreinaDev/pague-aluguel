require 'rails_helper'

describe Unit do
  context '.all' do
    it 'retorna todos as unidades' do
      data = Rails.root.join('spec/support/json/units.json').read
      response = double('response', success?: true, body: data)
      allow(Faraday).to receive(:get).with("#{Rails.configuration.api['base_url']}/condos/1/units")
                                     .and_return(response)

      result = Unit.all(1)

      expect(result.length).to eq 3
      expect(result[0].id).to eq 1
      expect(result[0].floor).to eq 1
      expect(result[0].number).to eq '11'
      expect(result[1].id).to eq 2
      expect(result[1].floor).to eq 2
      expect(result[1].number).to eq '21'
      expect(result[2].id).to eq 3
      expect(result[2].floor).to eq 3
      expect(result[2].number).to eq '31'
    end
  end

  context '.find' do
    it 'retorna uma unidade' do
      data = Rails.root.join('spec/support/json/unit.json').read
      response = double('response', success?: true, body: data)
      allow(Faraday).to receive(:get).with("#{Rails.configuration.api['base_url']}/units/1")
                                     .and_return(response)

      result = Unit.find(1)

      expect(result.id).to eq 1
      expect(result.area).to eq 150.45
      expect(result.floor).to eq 1
      expect(result.number).to eq '11'
      expect(result.condo_id).to eq 1
      expect(result.owner_id).to eq 1
      expect(result.description).to eq 'Duplex com varanda'
    end
  end

  context '.find_all_by_owner' do
    it 'retorna todas as unidades de um proprietario' do
      cpf = CPF.generate
      data = Rails.root.join('spec/support/json/owner_units.json').read
      response = double('response', success?: true, body: data)
      allow(Faraday).to(
        receive(:get).with("#{Rails.configuration.api['base_url']}/get_owner_properties?registration_number=#{cpf}")
        .and_return(response)
      )

      result = Unit.find_all_by_owner(cpf)

      expect(result.length).to eq 2
      expect(result[0].id).to eq 1
      expect(result[0].floor).to eq 2
      expect(result[0].number).to eq 10
      expect(result[1].id).to eq 2
      expect(result[1].floor).to eq 3
      expect(result[1].number).to eq 20
    end
  end

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
        bill = Bill.new(unit_id: units.first.id, condo_id: condos.first.id)
        bill = units.first.calculate_values(bill)
        bill.issue_date = Time.zone.today.beginning_of_month
        bill.due_date = Time.zone.today.beginning_of_month + 9.days
        bill.save!

        expect(bill.total_value_cents).to eq 170_011
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
        bill = Bill.new(unit_id: units.first.id, condo_id: condo.id)
        bill = units.first.calculate_values(bill)
        bill.issue_date = Time.zone.today.beginning_of_month
        bill.due_date = Time.zone.today.beginning_of_month + 9.days
        bill.save!

        expect(bill.total_value_cents).to eq 0
      end
    end
  end
end
