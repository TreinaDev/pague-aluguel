require 'rails_helper'

describe 'Admin registra uma taxa de área comum' do
  it 'com sucesso a partir da listagem de área comum' do
    admin = Admin.create!(email: 'ikki.phoenix@seiya.com', password: 'phoenix123')

    condo = Condo.create!(name: 'Sai de baixo', city: 'Rio de Janeiro')

    common_area = CommonArea.create!(name: 'TMNT', description: 'Teenage Mutant Ninja Turtles', max_capacity: 40,
                                     usage_rules: 'Não lutar no salão', condo:)
    CommonArea.create!(name: 'Saint Seiya', description: 'Os Cavaleiros dos zodíacos', max_capacity: 60,
                       usage_rules: 'Elevar o cosmos ao máximo.', condo:)

    login_as admin, scope: :admin
    visit common_areas_path
    within 'div#area-0' do
      click_on 'TMNT'
    end
    click_on 'Registrar Taxa'
    fill_in 'Taxa de área comum', with: '200'
    click_on 'Atualizar'

    expect(current_path).to eq common_area_path(common_area)
    expect(page).to have_content 'TMNT'
    expect(page).to have_content 'Descrição: Teenage Mutant Ninja Turtles'
    expect(page).to have_content 'Capacidade Máxima: 40'
    expect(page).to have_content 'Regras de uso: Não lutar no salão'
    expect(page).to have_content 'Taxa de área comum: R$ 200,00'
    expect(page).to have_content 'Taxa cadastrada com sucesso!'
  end

  it 'se estiver autenticado' do
    condo = Condo.create!(name: 'Sai de baixo', city: 'Rio de Janeiro')

    common_area = CommonArea.create!(name: 'TMNT', description: 'Teenage Mutant Ninja Turtles', max_capacity: 40,
                                     usage_rules: 'Não lutar no salão', condo:)

    visit edit_common_area_path(common_area)

    expect(current_path).to eq new_admin_session_path
  end

  it 'e a taxa é negativa' do
    admin = Admin.create!(email: 'ikki.phoenix@seiya.com', password: 'phoenix123')

    condo = Condo.create!(name: 'Sai de baixo', city: 'Rio de Janeiro')

    CommonArea.create!(name: 'TMNT', description: 'Teenage Mutant Ninja Turtles', max_capacity: 40,
                       usage_rules: 'Não lutar no salão', condo:)

    login_as admin, scope: :admin
    visit common_areas_path
    within 'div#area-0' do
      click_on 'TMNT'
    end
    click_on 'Registrar Taxa'
    fill_in 'Taxa de área comum', with: -300
    click_on 'Atualizar'

    expect(page).to have_content 'Não foi possível registrar a taxa.'
    expect(page).to have_content 'Atente-se aos erros abaixo:'
    expect(page).to have_content 'Taxa de área comum não pode ser negativa.'
  end
end
