require 'rails_helper'

describe Condo do
  context '.all' do
    it 'retorna todos os condominios' do
      data = File.read(Rails.root.join('spec/support/json/condos.json'))
      response = double('response', status: 200, body: data)
      allow(Faraday).to receive(:get).with('http://127.0.0.1:3000/api/v1/condos').and_return(response)

      result = Condo.all

      expect(result.length).to eq 3
      expect(result[0].name).to eq 'Sai de Baixo'
      expect(result[0].city).to eq 'Rio de Janeiro'
      expect(result[1].name).to eq 'Sai de Cima'
      expect(result[1].city).to eq 'Sao Paulo'
      expect(result[2].name).to eq 'Sai do Meio'
      expect(result[2].city).to eq 'Minas Gerais'
    end
  end
end
