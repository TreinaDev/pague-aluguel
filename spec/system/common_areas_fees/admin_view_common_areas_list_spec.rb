require 'rails_helper'

describe 'Admin vê a lista de áreas comuns' do
  it 'se estiver logado' do
    visit common_areas_path

    expect(current_path).not_to eq common_areas_path
    expect(current_path).to eq new_admin_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  xit 'a partir da homepage' do
  end

  it 'com sucesso' do
    admin = Admin.create!(email: 'ikki.phoenix@seiya.com', password: 'phoenix123')

    condo = Condo.create!(name: 'Sai de baixo', city: 'Rio de Janeiro')

    CommonArea.create!(name: 'TMNT', description: 'Teenage Mutant Ninja Turtles', max_capacity: 40,
                       usage_rules: 'Não lutar no salão', fee: 400.50, condo:)
    CommonArea.create!(name: 'Saint Seiya', description: 'Os Cavaleiros dos zodíacos', max_capacity: 60,
                       usage_rules: 'Elevar o cosmos ao máximo.', fee: 500, condo:)

    login_as admin, scope: :admin
    visit common_areas_path

    expect(page).to have_content 'TMNT'
    expect(page).to have_content 'Teenage Mutant Ninja Turtles'
    expect(page).to have_content '400.50'
    expect(page).to have_content 'Saint Seiya'
    expect(page).to have_content 'Os Cavaleiros dos zodíacos'
    expect(page).to have_content '500'
    expect(page).not_to have_content 'Nenhuma Área Comum cadastrada'
  end

  it 'E não existem áreas comuns cadastradas' do
    admin = Admin.create!(email: 'matheus@gmail.com', password: 'admin12345')

    login_as admin, scope: :admin
    visit common_areas_path

    expect(page).to have_content 'Nenhuma Área Comum cadastrada'
  end
end
