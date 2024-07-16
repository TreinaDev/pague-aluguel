require 'rails_helper'

describe Condo do
  context '.all' do
    it 'retorna todos os condominios' do
      data = Rails.root.join('spec/support/json/condos.json').read
      response = double('response', success?: true, body: data)
      allow(Faraday).to receive(:get).with('http://127.0.0.1:3000/api/v1/condos').and_return(response)

      result = Condo.all

      expect(result.length).to eq 3
      expect(result.first.id).to eq '1'
      expect(result.first.name).to eq 'Sai de Baixo'
      expect(result.first.city).to eq 'Rio de Janeiro'
      expect(result.second.id).to eq '2'
      expect(result.second.name).to eq 'Sai de Cima'
      expect(result.second.city).to eq 'Sao Paulo'
      expect(result.third.id).to eq '3'
      expect(result.third.name).to eq 'Sai do Meio'
      expect(result.third.city).to eq 'Belo Horizonte'
    end

    it 'não há condomínios cadastrados' do
      response = double('response', success?: true, body: '[]')
      allow(Faraday).to receive(:get).with('http://127.0.0.1:3000/api/v1/condos').and_return(response)

      result = Condo.all

      expect(result).to eq []
    end
  end

  context '.find' do
    it 'retorna o condomínio pelo ID' do
      condo_id = 1
      data = Rails.root.join('spec/support/json/condo.json').read
      response = double('response', success?: true, body: data)
      allow(Faraday).to receive(:get).with("http://127.0.0.1:3000/api/v1/condos/#{condo_id}").and_return(response)

      result = Condo.find(condo_id)

      expect(result.id).to eq condo_id
      expect(result.name).to eq 'Sai de Baixo'
      expect(result.city).to eq 'Rio Branco'
    end
  end
end
