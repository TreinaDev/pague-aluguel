require 'rails_helper'

describe UnitType do
  context '.all' do
    it 'Retorna todos os tipos de unidade de um condominio' do
      condo_id = 1
      data = Rails.root.join('spec/support/json/unit_types.json').read
      response = double('response', success?: true, body: data)
      allow(Faraday).to receive(:get).with("#{Rails.configuration.api['base_url']}/condos/#{condo_id}/unit_types")
                                     .and_return(response)

      result = UnitType.all(condo_id)

      expect(result.length).to eq 3
      expect(result.first.id).to eq 1
      expect(result.first.description).to eq 'something'
      expect(result.first.metreage).to eq 1000
      expect(result.first.fraction).to eq 10.1
      expect(result.first.unit_ids).to eq [1, 3, 5]
      expect(result.first.condo_id).to eq condo_id
      expect(result.second.id).to eq 2
      expect(result.second.description).to eq 'another thing'
      expect(result.second.metreage).to eq 2000
      expect(result.second.fraction).to eq 20.2
      expect(result.second.unit_ids).to eq [30, 32, 34]
      expect(result.second.condo_id).to eq condo_id
      expect(result.third.id).to eq 3
      expect(result.third.description).to eq 'yet another thing'
      expect(result.third.metreage).to eq 3000
      expect(result.third.fraction).to eq 30.3
      expect(result.third.unit_ids).to eq [56, 58, 60]
      expect(result.third.condo_id).to eq condo_id
    end
  end
end
