require 'rails_helper'

describe Condo do
  context '.all' do
    it 'retorna todos os condominios' do
      data = Rails.root.join('spec/support/json/condos.json').read
      response = double('response', success?: true, body: data)
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

    it '.find' do
      data = Rails.root.join('spec/support/json/condo.json').read
      response = double('response', success?: true, body: data)
      allow(Faraday).to receive(:get).with('http://127.0.0.1:3000/api/v1/condos/1').and_return(response)

      result = Condo.find(1)

      expect(result.name).to eq 'Sai de Baixo'
      expect(result.city).to eq 'Rio de Janeiro'
    end
  end
end
