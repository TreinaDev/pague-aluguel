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

  it '#identifier' do
    unit1 = Unit.new(id: 1, area: 40, floor: 1, number: 1, unit_type_id: 1)
    unit2 = Unit.new(id: 2, area: 40, floor: 2, number: 1, unit_type_id: 1)

    expect(unit1.identifier).to eq '11'
    expect(unit2.identifier).to eq '21'
  end
end
