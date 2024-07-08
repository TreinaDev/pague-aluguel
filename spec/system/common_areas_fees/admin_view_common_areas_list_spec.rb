require 'rails_helper'

describe 'Admin vê a lista de áreas comuns' do
  it 'se estiver autenticado' do
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')

    visit condo_common_areas_path(condo.id)

    expect(current_path).not_to eq condo_common_areas_path(condo.id)
    expect(current_path).to eq new_admin_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  # Unir com o teste de baixo
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

  xit 'e vê primeiras área comuns' do
    admin = create(:admin, email: 'ikki.phoenix@seiya.com', password: 'phoenix123')

    condos = []
    condos << Condo.new(id: 1, name: 'Prédio de Vidro', city: 'São Paulo')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)

    create(:common_area, name: 'Salão de Festas', description: 'Com pratos e copos', fee_cents: 500_00,
                         condo_id: condos.first.id)
    create(:common_area, name: 'Play', description: 'Vídeo Game', fee_cents: 400_00,
                         condo_id: condos.first.id)
    create(:common_area, name: 'Academia', description: 'Pesos livres e esteiras', fee_cents: 400_00,
                         condo_id: condos.first.id)
    create(:common_area, name: 'Parquinho', description: 'Escorregador e balanço', fee_cents: 400_00,
                         condo_id: condos.first.id)
    create(:common_area, name: 'Cinema', description: 'Titanic todo dia', fee_cents: 400_00,
                         condo_id: condos.first.id)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Prédio de Vidro'

    expect(page).to have_content 'Áreas Comuns'
    expect(page).to have_content 'Play'
    expect(page).to have_content 'Academia'
    expect(page).to have_content 'Parquinho'
    expect(page).to have_content 'Salão de Festas'
    expect(page).not_to have_content 'Cinema'
    expect(page).not_to have_content 'Nenhuma área comum cadastrada.'
  end

  xit 'e vê todas as áreas comuns' do
    admin = create(:admin, email: 'ikki.phoenix@seiya.com', password: 'phoenix123')

    condos = []
    condos << Condo.new(id: 1, name: 'Prédio de Vidro', city: 'São Paulo')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)

    create(:common_area, name: 'Salão de Festas', description: 'Com pratos e copos', fee_cents: 500_00,
                         condo_id: condos.first.id)
    create(:common_area, name: 'Play', description: 'Vídeo Game', fee_cents: 400_00,
                         condo_id: condos.first.id)
    create(:common_area, name: 'Academia', description: 'Pesos livres e esteiras', fee_cents: 400_00,
                         condo_id: condos.first.id)
    create(:common_area, name: 'Parquinho', description: 'Escorregador e balanço', fee_cents: 400_00,
                         condo_id: condos.first.id)
    create(:common_area, name: 'Cinema', description: 'Titanic todo dia', fee_cents: 400_00,
                         condo_id: condos.first.id)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Prédio de Vidro'
    within 'div#common-areas' do
      click_on 'Mostrar todos'
      expect(page).to have_content 'Áreas Comuns'
      expect(page).to have_content 'Salão de Festas'
      expect(page).to have_content 'Play'
      expect(page).to have_content 'Academia'
      expect(page).to have_content 'Parquinho'
      expect(page).to have_content 'Cinema'
      expect(page).not_to have_content 'Nenhuma área comum cadastrada.'
    end
  end

  it 'e não existem áreas comuns cadastradas' do
    admin = create(:admin, email: 'matheus@gmail.com', password: 'admin12345')
    condo = Condo.new(id: 1, name: 'Condo TMNT', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)
    fake_response = double('faraday_response', status: 200, body: '[]', success?: true)
    allow(Faraday).to receive(:get).with("http://127.0.0.1:3000/api/v1/condos/#{condo.id}/common_areas").and_return(fake_response)

    login_as admin, scope: :admin
    visit condo_path(condo.id)

    expect(page).to have_content 'Nenhuma área comum cadastrada.'
  end

  xit 'e vê somente as áreas comuns do condomínio selecionado' do
    admin = create(:admin)

    condo = Condo.new(id: 1, name: 'Teenage Mutant Ninja Turtles', city: 'São Paulo')
    second_condo = Condo.new(id: 2, name: 'Teenage', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo, second_condo)

    create(:common_area, name: 'TMNT', condo_id: condo.id)
    create(:common_area, name: 'Saint Seiya', condo_id: condo.id)
    create(:common_area, name: 'Naruto', condo_id: second_condo.id)
    create(:common_area, name: 'Jiraya', condo_id: second_condo.id)

    login_as admin, scope: :admin
    visit condo_path(condo.id)

    expect(page).to have_content 'TMNT'
    expect(page).to have_content 'Saint Seiya'
    expect(page).not_to have_content 'Naruto'
    expect(page).not_to have_content 'Jiraya'
  end

  xit 'e vê áreas comuns sem taxa cadastradas' do
    admin = create(:admin)

    condo = Condo.new(id: 1, name: 'Teenage Mutant Ninja Turtles', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    common_area = create(:common_area, name: 'TMNT', fee_cents: 0, condo_id: condo.id)

    login_as admin, scope: :admin
    visit condo_common_area_path(condo.id, common_area.id)

    expect(page).to have_content 'Taxa não cadastrada'
  end

  it 'e acessa uma área comum e volta para a lista' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Teenage Mutant Ninja Turtles', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Academia',
                                   description: 'Uma academia raíz com ventilador apenas para os marombas',
                                   max_occupancy: 20, rules: 'Não pode ser frango')
    common_areas << CommonArea.new(id: 1, name: 'Piscina', description: 'Piscina grande cabe até golfinhos.',
                                   max_occupancy: 50, rules: 'Não pode comida aos arredores da área da piscina.')
    common_areas << CommonArea.new(id: 1, name: 'Salão de festa', description: 'Festa para toda a família.',
                                   max_occupancy: 50, rules: 'Não é permitido a entrada de leões')
    allow(CommonArea).to receive(:all).and_return(common_areas)
    common_area = common_areas.first.to_json
    fake_response = double('faraday_response', status: 200, body: common_area, success?: true)
    allow(Faraday).to receive(:get).with("http://127.0.0.1:3000/api/v1/condos/#{condo.id}/common_areas/1").and_return(fake_response)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo.id)
    # visit condo_path(condo.id)
    click_on 'Academia'
    find('#close').click

    expect(page).to have_content 'Academia'
    expect(page).to have_content 'Uma academia raíz com ventilador apenas para os marombas'
    expect(page).to have_content 'Piscina'
    expect(page).to have_content 'Piscina grande cabe até golfinhos.'
  end

  it 'e volta para show do condomínio' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Teenage Mutant Ninja Turtles', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    visit condo_common_area_path(condo.id, common_area.id)
    find('#close').click

    expect(current_path).to eq condo_path(condo.id)
  end

  xit 'e não há nenhuma cadastrada' do
  end
end
