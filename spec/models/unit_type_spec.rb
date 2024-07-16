require 'rails_helper'

describe UnitType do
  context '.all' do
    it 'Retorna todos os tipos de unidade de um condominio' do
      data = Rails.root.join('spec/support/json/unit_types.json').read
      response = double('response', success?: true, body: data)
      allow(Faraday).to receive(:get).with("#{Rails.configuration.api['base_url']}/condos/1/unit_types")
                                     .and_return(response)

      result = UnitType.all(1)

      expect(result.length).to eq 3
      expect(result[0].id).to eq 1
      expect(result[0].description).to eq 'something'
      expect(result[0].metreage).to eq 1000
      expect(result[0].fraction).to eq 10.1
      expect(result[1].id).to eq 2
      expect(result[1].description).to eq 'another thing'
      expect(result[1].metreage).to eq 2000
      expect(result[1].fraction).to eq 20.2
      expect(result[2].id).to eq 3
      expect(result[2].description).to eq 'yet another thing'
      expect(result[2].metreage).to eq 3000
      expect(result[2].fraction).to eq 30.3
    end
  end
end
