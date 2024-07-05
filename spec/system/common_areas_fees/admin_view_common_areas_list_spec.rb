require 'rails_helper'

describe 'Admin vê a lista de áreas comuns' do
  it 'se estiver autenticado' do
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')

    visit condo_common_areas_path(condo.id)

    expect(current_path).not_to eq condo_common_areas_path(condo.id)
    expect(current_path).to eq new_admin_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'com sucesso' do
    admin = create(:admin, email: 'matheus@gmail.com', password: 'admin12345')
    condo = Condo.new(id: 1, name: 'Condo TMNT', city: 'Salvador')
    allow(Condo).to receive(:find).and_return(condo)
    json_data = File.read('spec/support/json/common_areas.json')
    fake_response = double('faraday_response', status: 200, body: json_data, success?: true)
    allow(Faraday).to receive(:get).with("http://127.0.0.1:3000/api/v1/condos/#{condo.id}/common_areas").and_return(fake_response)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo.id)

    expect(page).to have_content 'Áreas comuns do condomínio Condo TMNT'
    expect(page).to have_content 'Academia'
    expect(page).to have_content 'Uma academia raíz com ventilador apenas para os marombas'
    expect(page).to have_content 'Piscina'
    expect(page).to have_content 'Piscina grande cabe até golfinhos.'
    expect(page).not_to have_content 'Nenhuma Área Comum cadastrada'
  end

  it 'E não existem áreas comuns cadastradas' do
    admin = create(:admin, email: 'matheus@gmail.com', password: 'admin12345')
    condo = Condo.new(id: 1, name: 'Condo TMNT', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)
    fake_response = double('faraday_response', status: 200, body: '[]', success?: true)
    allow(Faraday).to receive(:get).with("http://127.0.0.1:3000/api/v1/condos/#{condo.id}/common_areas").and_return(fake_response)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo.id)

    expect(page).to have_content 'Nenhuma Área Comum cadastrada'
  end

  it 'e acessa uma área comum e volta para a lista' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Teenage Mutant Ninja Turtles', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)
    json_data = File.read('spec/support/json/common_areas.json')
    fake_response = double('faraday_response', status: 200, body: json_data, success?: true)
    allow(Faraday).to receive(:get).with("http://127.0.0.1:3000/api/v1/condos/#{condo.id}/common_areas").and_return(fake_response)
    common_area = JSON.parse(json_data).first.to_json
    fake_response = double('faraday_response', status: 200, body: common_area, success?: true)
    allow(Faraday).to receive(:get).with("http://127.0.0.1:3000/api/v1/condos/#{condo.id}/common_areas/1").and_return(fake_response)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo.id)
    click_on 'Academia'
    click_on 'Voltar'

    expect(page).to have_content 'Academia'
    expect(page).to have_content 'Uma academia raíz com ventilador apenas para os marombas'
    expect(page).to have_content 'Piscina'
    expect(page).to have_content 'Piscina grande cabe até golfinhos.'
  end

  # Só será possível se tivermos o show do condomínio
  xit 'e volta para show do condomínio' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Teenage Mutant Ninja Turtles', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    create(:common_area, name: 'TMNT', fee_cents: 400_00, condo_id: condo.id)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo.id)
    click_on 'Voltar'

    expect(current_path).to eq condo_path(condo.id)
  end
end
