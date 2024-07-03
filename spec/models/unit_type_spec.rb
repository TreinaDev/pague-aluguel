require 'rails_helper'

describe UnitType do
  context '.all' do
    it 'Retorna todos os tipos de unidade' do
      data = File.read(Rails.root.join('spec/support/json/unit_types.json'))
      response = double('response', success?: true, body: data)
      allow(Faraday).to receive(:get).with('http://127.0.0.1:3000/api/v1/unit_types').and_return(response)

      result = UnitType.all

      expect(result.length).to eq 3
      expect(result[0].description).to eq 'something'
      expect(result[1].description).to eq 'another thing'
      expect(result[2].description).to eq 'yet another thing'
    end
  end
end
