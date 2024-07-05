require 'rails_helper'

describe 'Admin registra uma taxa de área comum' do
  it 'com sucesso a partir da listagem de área comum' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Teenage Mutant Ninja Turtles', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)
    json_data = File.read('spec/support/json/common_areas.json')
    fake_response = double('faraday_response', status: 200, body: json_data, success?: true)
    allow(Faraday).to receive(:get).with("http://127.0.0.1:3000/api/v1/condos/#{condo.id}/common_areas").and_return(fake_response)
    common_area = JSON.parse(json_data).first
    common_area_json = common_area.to_json
    fake_response = double('faraday_response', status: 200, body: common_area_json, success?: true)
    allow(Faraday).to receive(:get).with("http://127.0.0.1:3000/api/v1/condos/#{condo.id}/common_areas/#{common_area['id']}").and_return(fake_response)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo.id)
    within 'div#area-0' do
      click_on 'Academia'
    end
    click_on 'Registrar Taxa'
    fill_in 'Taxa', with: '200,50'
    click_on 'Criar Taxa de Área Comum'

    expect(page).to have_content 'Taxa cadastrada com sucesso!'
    expect(current_path).to eq condo_common_area_path(condo.id, common_area['id'])
    expect(page).to have_content 'Taxa de área comum: R$200,50'
  end

  it 'se estiver autenticado' do
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)
    json_data = File.read('spec/support/json/common_areas.json')
    fake_response = double('faraday_response', status: 200, body: json_data, success?: true)
    allow(Faraday).to receive(:get).with("http://127.0.0.1:3000/api/v1/condos/#{condo.id}/common_areas").and_return(fake_response)
    common_area = JSON.parse(json_data).first
    common_area_json = common_area.to_json
    fake_response = double('faraday_response', status: 200, body: common_area_json, success?: true)
    allow(Faraday).to receive(:get).with("http://127.0.0.1:3000/api/v1/condos/#{condo.id}/common_areas/#{common_area['id']}").and_return(fake_response)

    visit new_condo_common_area_common_area_fee_path(condo.id, common_area['id'])

    expect(current_path).to eq new_admin_session_path
  end

  #         TESTE UNITARIO DE TAXA NEGATIVA NO MODEL

  it 'e deixa em branco' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)
    json_data = File.read('spec/support/json/common_areas.json')
    fake_response = double('faraday_response', status: 200, body: json_data, success?: true)
    allow(Faraday).to receive(:get).with("http://127.0.0.1:3000/api/v1/condos/#{condo.id}/common_areas").and_return(fake_response)
    common_area = JSON.parse(json_data).first
    common_area_json = common_area.to_json
    fake_response = double('faraday_response', status: 200, body: common_area_json, success?: true)
    allow(Faraday).to receive(:get).with("http://127.0.0.1:3000/api/v1/condos/#{condo.id}/common_areas/#{common_area['id']}").and_return(fake_response)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo.id)
    within 'div#area-0' do
      click_on 'Academia'
    end
    click_on 'Registrar Taxa'
    fill_in 'Taxa', with: ''
    click_on 'Criar Taxa de Área Comum'

    expect(page).to have_content 'Não foi possível registrar a taxa.'
    expect(page).to have_content 'Por favor, corrija os seguintes erros:'
    expect(page).to have_content 'Taxa não é um número'
  end

  it 'e cancela o registro e volta para show' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Teenage Mutant Ninja Turtles', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)
    json_data = File.read('spec/support/json/common_areas.json')
    fake_response = double('faraday_response', status: 200, body: json_data, success?: true)
    allow(Faraday).to receive(:get).with("http://127.0.0.1:3000/api/v1/condos/#{condo.id}/common_areas").and_return(fake_response)
    common_area = JSON.parse(json_data).first
    common_area_json = common_area.to_json
    fake_response = double('faraday_response', status: 200, body: common_area_json, success?: true)
    allow(Faraday).to receive(:get).with("http://127.0.0.1:3000/api/v1/condos/#{condo.id}/common_areas/#{common_area['id']}").and_return(fake_response)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo.id)
    within 'div#area-0' do
      click_on 'Academia'
    end
    click_on 'Registrar Taxa'
    fill_in 'Taxa', with: '200,50'
    click_on 'Cancelar'

    expect(current_path).to eq condo_common_area_path(condo.id, common_area['id'])
  end
end
