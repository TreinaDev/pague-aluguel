require 'rails_helper'

RSpec.describe CommonArea, type: :model do
  it 'inicializa uma CommonArea com os atributos dados' do
    attributes = {
      id: 1,
      condo_id: 2,
      name: 'Piscina',
      description: 'Uma grande piscina',
      max_occupancy: 50,
      rules: 'Não correr'
    }

    common_area = CommonArea.new(attributes)

    expect(common_area.id).to eq(attributes[:id])
    expect(common_area.condo_id).to eq(attributes[:condo_id])
    expect(common_area.name).to eq(attributes[:name])
    expect(common_area.description).to eq(attributes[:description])
    expect(common_area.max_occupancy).to eq(attributes[:max_occupancy])
    expect(common_area.rules).to eq(attributes[:rules])
  end

  describe 'requests' do
    it 'retorna uma lista de áreas comuns com sucesso (.all)' do
      condo_id = 1
      json_data = File.read('spec/support/json/common_areas.json')
      fake_response = double('faraday_response', status: 200, body: json_data, success?: true)
      allow(Faraday).to receive(:get).with("http://127.0.0.1:3000/api/v1/condos/#{condo_id}/common_areas").and_return(fake_response)

      common_areas = CommonArea.all(condo_id)

      expect(common_areas.length).to eq(6)
      expect(common_areas.first.name).to eq 'Academia'
      expect(common_areas.second.name).to eq 'Piscina'
    end

    it 'retorna os detalhes de uma area comum com sucesso (.find)' do
      condo_id = 1
      common_area_id = 1
      json_data = File.read('spec/support/json/common_areas.json')
      first_common_area_json = JSON.parse(json_data).first.to_json
      fake_response = double('faraday_response', status: 200, body: first_common_area_json, success?: true)
      allow(Faraday).to receive(:get).with("http://127.0.0.1:3000/api/v1/condos/#{condo_id}/common_areas/#{common_area_id}").and_return(fake_response)

      common_area = CommonArea.find(condo_id, common_area_id)

      expect(common_area).not_to be_nil
      expect(common_area.name).to eq 'Academia'
      expect(common_area.description).to eq 'Uma academia raíz com ventilador apenas para os marombas'
    end
  end
end
