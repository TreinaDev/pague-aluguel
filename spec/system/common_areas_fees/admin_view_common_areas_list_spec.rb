require 'rails_helper'

describe 'Admin vê a lista de áreas comuns' do
  it 'se estiver autenticado' do
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    visit condo_common_areas_path(condo.id)

    expect(current_path).not_to eq condo_common_areas_path(condo.id)
    expect(current_path).to eq new_admin_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'com sucesso' do
    admin = create(:admin, email: 'ikki.phoenix@seiya.com', password: 'phoenix123')

    condos = []
    condos << Condo.new(id: 1, name: 'Teenage Mutant Ninja Turtles', city: 'São Paulo')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)

    create(:common_area, name: 'TMNT', description: 'Teenage Mutant Ninja Turtles', fee_cents: 500_00,
                         condo_id: condos.first.id)
    create(:common_area, name: 'Saint Seiya', description: 'Os Cavaleiros dos zodíacos', fee_cents: 400_00,
                         condo_id: condos.first.id)

    login_as admin, scope: :admin
    visit root_path
    click_on 'Teenage Mutant Ninja Turtles'
    click_on 'TMNT'

    expect(page).to have_content 'Área Comum'
    expect(page).to have_content 'TMNT'
    expect(page).to have_content 'Teenage Mutant Ninja Turtles'
    expect(page).to have_content 'Saint Seiya'
    expect(page).to have_content 'Os Cavaleiros dos zodíacos'
    expect(page).not_to have_content 'Nenhuma área comum cadastrada.'
  end

  it 'e não existem áreas comuns cadastradas' do
    admin = create(:admin, email: 'matheus@gmail.com', password: 'admin12345')

    condo = Condo.new(id: 1, name: 'Teenage Mutant Ninja Turtles', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    login_as admin, scope: :admin
    visit condo_path(condo.id)

    expect(page).to have_content 'Nenhuma área comum cadastrada.'
  end

  it 'e vê somente as áreas comuns do condomínio selecionado' do
    admin = create(:admin)

    condo = Condo.new(id: 1, name: 'Teenage Mutant Ninja Turtles', city: 'São Paulo')
    second_condo = Condo.new(id: 2, name: 'Teenage', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo, second_condo)

    create(:common_area, name: 'TMNT', condo_id: condo.id)
    create(:common_area, name: 'Saint Seiya', condo_id: condo.id)
    create(:common_area, name: 'Naruto', condo_id: second_condo.id)
    create(:common_area, name: 'Jiraya', condo_id: second_condo.id)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo.id)

    expect(page).to have_content 'TMNT'
    expect(page).to have_content 'Saint Seiya'
    expect(page).not_to have_content 'Naruto'
    expect(page).not_to have_content 'Jiraya'
  end

  it 'e vê áreas comuns sem taxa cadastradas' do
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

    create(:common_area, name: 'TMNT', fee_cents: 400_00, condo_id: condo.id)
    create(:common_area, name: 'Saint Seiya', fee_cents: 500_00, condo_id: condo.id)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo.id)
    click_on 'TMNT'
    find('#close').click

    expect(page).to have_content 'TMNT'
    expect(page).to have_content 'Saint Seiya'
  end

  it 'e volta para show do condomínio' do
    admin = create(:admin)

    condo = Condo.new(id: 1, name: 'Teenage Mutant Ninja Turtles', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    common_area = create(:common_area, name: 'TMNT', fee_cents: 400_00, condo_id: condo.id)

    login_as admin, scope: :admin
    visit condo_common_area_path(condo.id, common_area.id)
    find('#close').click

    expect(current_path).to eq condo_path(condo.id)
  end
end
