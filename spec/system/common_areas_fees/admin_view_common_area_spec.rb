require 'rails_helper'

describe 'Admin vê área comum' do
  it 'com sucesso' do
    admin = Admin.create!(email: 'ikki.phoenix@seiya.com', password: 'phoenix123')
    condo = FactoryBot.create(:condo)
    CommonArea.create!(name: 'TMNT', description: 'Teenage Mutant Ninja Turtles', max_capacity: 40,
                       usage_rules: 'Não lutar no salão', fee: 200, condo:)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo)
    within 'div#area-0' do
      click_on 'TMNT'
    end

    expect(page).to have_content 'TMNT'
    expect(page).to have_content 'Descrição: Teenage Mutant Ninja Turtles'
    expect(page).to have_content 'Capacidade máxima: 40'
    expect(page).to have_content 'Regras de uso: Não lutar no salão'
    expect(page).to have_content 'Taxa de área comum: R$ 200,00'
  end

  it 'e taxa não está cadastrada' do
    admin = Admin.create!(email: 'ikki.phoenix@seiya.com', password: 'phoenix123')
    condo = FactoryBot.create(:condo)
    common_area = FactoryBot.create(:common_area, fee: 0, condo:)

    login_as admin, scope: :admin
    visit condo_common_area_path(condo, common_area)

    expect(page).to have_content 'Taxa não cadastrada'
  end
end
