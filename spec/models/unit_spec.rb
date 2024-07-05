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
end
