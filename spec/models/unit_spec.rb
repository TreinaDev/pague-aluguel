require 'rails_helper'

describe Unit do
  context '.all' do
    it 'retorna todos as unidades' do
      data = Rails.root.join('spec/support/json/units.json').read
      response = double('response', success?: true, body: data)
      allow(Faraday).to receive(:get).with('http://127.0.0.1:3000/api/v1/units').and_return(response)

      result = Unit.all

      expect(result.length).to eq 3
      expect(result[0].area).to eq 100
      expect(result[0].floor).to eq 1
      expect(result[0].number).to eq 1
      expect(result[1].area).to eq 200
      expect(result[1].floor).to eq 2
      expect(result[1].number).to eq 2
      expect(result[2].area).to eq 300
      expect(result[2].floor).to eq 3
      expect(result[2].number).to eq 3
    end
  end

  context '.identifier' do
    it 'retorna o número do apartamento' do
      unit1 = Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
      unit2 = Unit.new(id: 2, area: 40, floor: 2, number: 1, unit_type_id: 1)

      expect(unit1.identifier).to eq '11'
      expect(unit2.identifier).to eq '21'
    end
  end

  context '.find' do
    it 'retorna uma unidade' do
      data = Rails.root.join('spec/support/json/unit.json').read
      response = double('response', success?: true, body: data)
      allow(Faraday).to receive(:get).with('http://127.0.0.1:3000/api/v1/units/1').and_return(response)

      result = Unit.find(1)

      expect(result.area).to eq 100
      expect(result.floor).to eq 1
      expect(result.number).to eq 1
    end
  end

  context '.find_all_by_owner' do
    it 'retorna todas as unidades de um proprietário' do
      cpf = CPF.generate
      data_owner_units = Rails.root.join('spec/support/json/owner_units.json').read
      response = double('response', success?: true, body: data_owner_units)
      allow(Faraday).to(
        receive(:get)
        .with("#{Rails.configuration.api['base_url']}/get_owner_properties?registration_number=#{cpf}")
        .and_return(response)
      )

      result = Unit.find_all_by_owner(cpf)

      expect(result[0].id).to eq 1
      expect(result[0].condo_name).to eq 'Bela Jardins'
      expect(result[0].area).to eq 100

      expect(result[1].id).to eq 2
      expect(result[1].condo_name).to eq 'Sai de Baixo'
      expect(result[1].area).to eq 80
    end
  end

  context '.set_status' do
    it 'retorna status da unidade' do
      unit1 = Unit.new(owner_id: 1, tenant_id: 1)
      unit2 = Unit.new(owner_id: 2, tenant_id: 1)
      unit3 = Unit.new(owner_id: 3, tenant_id: nil)

      expect(unit1.set_status).to eq 'Você reside nesta unidade'
      expect(unit2.set_status).to eq 'Esta unidade está alugada'
      expect(unit3.set_status).to eq 'Esta unidade está disponível para locação'
    end
  end

  context '.unit_has_tenant?' do
    it 'retorna verdadeiro se a unidade estiver alugada' do
      unit1 = Unit.new(owner_id: 1, tenant_id: 1)
      unit2 = Unit.new(owner_id: 2, tenant_id: 1)
      unit3 = Unit.new(owner_id: 3, tenant_id: nil)

      expect(unit1.unit_has_tenant?).to eq false
      expect(unit2.unit_has_tenant?).to eq true
      expect(unit3.unit_has_tenant?).to eq false
    end
  end
end
