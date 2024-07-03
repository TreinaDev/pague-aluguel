require 'rails_helper'

describe 'Admin vê área comum' do
  it 'com sucesso' do
    admin = create(:admin, email: 'ikki.phoenix@seiya.com', password: 'phoenix123')
    condo = FactoryBot.create(:condo)
    CommonArea.create!(name: 'TMNT', description: 'Teenage Mutant Ninja Turtles', max_capacity: 40,
                       usage_rules: 'Não lutar no salão', fee_cents: 200_00, condo:)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo)
    within 'div#area-0' do
      click_on 'TMNT'
    end

    expect(page).to have_content 'TMNT'
    expect(page).to have_content 'Descrição: Teenage Mutant Ninja Turtles'
    expect(page).to have_content 'Capacidade máxima: 40'
    expect(page).to have_content 'Regras de uso: Não lutar no salão'
    expect(page).to have_content 'Taxa de área comum: R$200,00'
  end

  it 'e taxa não está cadastrada' do
    admin = create(:admin, email: 'ikki.phoenix@seiya.com', password: 'phoenix123')
    condo = FactoryBot.create(:condo)
    common_area = FactoryBot.create(:common_area, fee_cents: 0, condo:)

    login_as admin, scope: :admin
    visit condo_common_area_path(condo, common_area)

    expect(page).to have_content 'Taxa não cadastrada'
  end

  it 'e vê histórico de taxas' do
    admin = create(:admin, email: 'ikki.phoenix@seiya.com', password: 'phoenix123')
    condo = FactoryBot.create(:condo)
    common_area = FactoryBot.create(:common_area, fee_cents: 0, condo:)

    login_as admin, scope: :admin

    visit condo_common_area_path(condo, common_area)
    click_on 'Registrar Taxa'
    fill_in 'Taxa de área comum', with: '200,00'
    click_on 'Atualizar'
    travel 1.month
    click_on 'Registrar Taxa'
    fill_in 'Taxa de área comum', with: '300,00'
    click_on 'Atualizar'
    click_on 'Mostrar histórico de taxas'

    expect(page).to have_content 'ikki.phoenix@seiya.com'
    expect(page).to have_content 'R$200,00'
    expect(page).to have_content 1.month.ago.strftime('%d/%m/%Y')
    expect(page).to have_content 'R$300,00'
    expect(page).to have_content Time.zone.today.strftime('%d/%m/%Y')
  end

  it 'e o histórico de taxas não existe' do
    admin = create(:admin, email: 'ikki.phoenix@seiya.com', password: 'phoenix123')
    condo = FactoryBot.create(:condo)
    common_area = FactoryBot.create(:common_area, fee_cents: 0, condo:)

    login_as admin, scope: :admin
    visit condo_common_area_path(condo, common_area)

    expect(page).not_to have_link 'Mostrar histórico de taxas'
  end
end
