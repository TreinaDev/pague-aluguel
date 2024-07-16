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
    condos = []
    condos << Condo.new(id: 1, name: 'Condo TMNT', city: 'Salvador')
    condo = condos.first
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo)

    common_areas = []
    common_areas << CommonArea.new(id: 3, name: 'Academia',
                                   description: 'Uma academia raíz com ventilador apenas para os marombas')
    common_areas << CommonArea.new(id: 2, name: 'Piscina',
                                   description: 'Piscina grande cabe até golfinhos.')
    allow(CommonArea).to receive(:all).with(1).and_return(common_areas)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo TMNT'

    expect(page).to have_content 'Condo TMNT'
    expect(page).to have_content 'Salvador'
    expect(page).to have_content 'Academia'
    expect(page).to have_content 'Uma academia raíz com ventilador apenas para os marombas'
    expect(page).to have_content 'Piscina'
    expect(page).to have_content 'Piscina grande cabe até golfinhos.'
    expect(page).not_to have_content 'Nenhuma Área Comum cadastrada'
  end

  it 'e vê todas as áreas comuns' do
    admin = create(:admin, email: 'matheus@gmail.com', password: 'admin12345')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo TMNT', city: 'Salvador')
    condo = condos.first
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo)

    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Piscina',
                                   description: 'Piscina grande cabe até golfinhos.')
    common_areas << CommonArea.new(id: 2, name: 'Academia',
                                   description: 'Uma academia raíz com ventilador apenas para os marombas')
    common_areas << CommonArea.new(id: 3, name: 'Salão de Festa',
                                   description: 'Salão preparado para grandes festas')
    common_areas << CommonArea.new(id: 4, name: 'Jardim Botânico Interno',
                                   description: 'Hambiente relaxante')
    common_areas << CommonArea.new(id: 5, name: 'Playground',
                                   description: 'Habiente para toda família')
    common_areas << CommonArea.new(id: 6, name: 'Salão de Jogos',
                                   description: 'Jogos para toda família')
    allow(CommonArea).to receive(:all).with(1).and_return(common_areas)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo TMNT'
    click_on 'Mostrar todos'

    expect(page).to have_content 'Condo TMNT'
    expect(page).to have_content 'Salvador'
    expect(page).to have_content 'Academia'
    expect(page).to have_content 'Uma academia raíz com ventilador apenas para os marombas'
    expect(page).to have_content 'Piscina'
    expect(page).to have_content 'Piscina grande cabe até golfinhos.'
    expect(page).to have_content 'Jardim Botânico Interno'
    expect(page).to have_content 'Playground'
    expect(page).to have_content 'Salão de Jogos'
    expect(page).to have_content 'Salão de Festa'
    expect(page).not_to have_content 'Nenhuma Área Comum cadastrada'
  end

  it 'e não existem áreas comuns cadastradas' do
    admin = create(:admin, email: 'matheus@gmail.com', password: 'admin12345')
    condo = Condo.new(id: 1, name: 'Condo TMNT', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    allow(CommonArea).to receive(:all).with(1).and_return([])

    login_as admin, scope: :admin
    visit condo_path(condo.id)

    expect(page).to have_content 'Nenhuma área comum cadastrada.'
  end

  it 'e vê áreas comuns sem taxa cadastradas' do
    admin = create(:admin, email: 'matheus@gmail.com', password: 'admin12345')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo TMNT', city: 'Salvador')
    condo = condos.first
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo)
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Piscina',
                                   description: 'Piscina grande cabe até golfinhos.',
                                   max_occupancy: 20, rules: 'Não pode comida aos arredores da área da piscina.')
    allow(CommonArea).to receive(:all).and_return(common_areas)
    allow(CommonArea).to receive(:find).and_return(common_areas.first)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo TMNT'
    within 'div#common-areas' do
      click_on 'Piscina'
    end

    expect(page).to have_content 'Taxa não cadastrada'
  end

  it 'e acessa uma área comum e volta para a lista' do
    admin = create(:admin, email: 'matheus@gmail.com', password: 'admin12345')
    condos = []
    condos << Condo.new(id: 1, name: 'Condo TMNT', city: 'Salvador')
    condo = condos.first
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo)

    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Salão de festa',
                                   description: 'Festa para toda a família.',
                                   max_occupancy: 20, rules: 'Não é permitido a entrada de leões')
    common_areas << CommonArea.new(id: 1, name: 'Piscina',
                                   description: 'Piscina grande cabe até golfinhos.',
                                   max_occupancy: 20, rules: 'Não pode comida aos arredores da área da piscina.')
    allow(CommonArea).to receive(:all).and_return(common_areas)
    allow(CommonArea).to receive(:find).and_return(common_areas.first)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Condo TMNT'
    within 'div#common-areas' do
      click_on 'Salão de festa'
    end
    find('#close').click

    expect(page).to have_content 'Salão de festa'
    expect(page).to have_content 'Festa para toda a família.'
    expect(page).to have_content 'Piscina'
    expect(page).to have_content 'Piscina grande cabe até golfinhos.'
    expect(page).not_to have_content 'Não é permitido a entrada de leões'
    expect(page).not_to have_content 'Taxa de área comum'
  end
end
