require 'rails_helper'

describe 'Admin vê a lista de áreas comuns' do
  it 'se estiver autenticado' do
    condo = FactoryBot.create(:condo)

    visit condo_common_areas_path(condo)

    expect(current_path).not_to eq condo_common_areas_path(condo)
    expect(current_path).to eq new_admin_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'com sucesso' do
    admin = Admin.create!(email: 'ikki.phoenix@seiya.com', password: 'phoenix123')

    condo = FactoryBot.create(:condo)
    FactoryBot.create(:common_area, name: 'TMNT', description: 'Teenage Mutant Ninja Turtles', fee: 500, condo:)
    FactoryBot.create(:common_area, name: 'Saint Seiya', description: 'Os Cavaleiros dos zodíacos', fee: 400, condo:)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo)

    expect(page).to have_content 'TMNT'
    expect(page).to have_content 'Teenage Mutant Ninja Turtles'
    expect(page).to have_content 'R$ 400,00'
    expect(page).to have_content 'Saint Seiya'
    expect(page).to have_content 'Os Cavaleiros dos zodíacos'
    expect(page).to have_content 'R$ 500,00'
    expect(page).not_to have_content 'Nenhuma Área Comum cadastrada'
  end

  it 'E não existem áreas comuns cadastradas' do
    admin = Admin.create!(email: 'matheus@gmail.com', password: 'admin12345')
    condo = FactoryBot.create(:condo)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo)

    expect(page).to have_content 'Nenhuma Área Comum cadastrada'
  end

  it 'e vê somente as áreas comuns do condomínio selecionado' do
    admin = Admin.create!(email: 'ikki.phoenix@seiya.com', password: 'phoenix123')

    condo = FactoryBot.create(:condo)
    second_condo = FactoryBot.create(:condo)
    FactoryBot.create(:common_area, name: 'TMNT', condo:)
    FactoryBot.create(:common_area, name: 'Saint Seiya', condo:)
    FactoryBot.create(:common_area, name: 'Naruto', condo: second_condo)
    FactoryBot.create(:common_area, name: 'Jiraya', condo: second_condo)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo)

    expect(page).to have_content 'TMNT'
    expect(page).to have_content 'Saint Seiya'
    expect(page).not_to have_content 'Naruto'
    expect(page).not_to have_content 'Jiraya'
  end
end
