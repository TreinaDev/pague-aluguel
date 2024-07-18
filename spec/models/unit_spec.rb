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
end
