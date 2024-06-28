require 'rails_helper'

describe 'Admin registra uma taxa de área comum' do
  it 'com sucesso a partir da listagem de área comum' do
    admin = Admin.create!(email: 'ikki.phoenix@seiya.com', password: 'phoenix123')

    condo = FactoryBot.create(:condo)

    common_area = FactoryBot.create(:common_area, name: 'TMNT', condo:)
    FactoryBot.create(:common_area, condo:)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo)
    within 'div#area-0' do
      click_on 'TMNT'
    end
    click_on 'Registrar Taxa'
    fill_in 'Taxa de área comum', with: '200'
    click_on 'Atualizar'

    expect(current_path).to eq condo_common_area_path(condo, common_area)
    expect(page).to have_content 'Taxa de área comum: R$ 200,00'
    expect(page).to have_content 'Taxa cadastrada com sucesso!'
  end

  it 'se estiver autenticado' do
    condo = FactoryBot.create(:condo)

    common_area = FactoryBot.create(:common_area, condo:)

    visit edit_condo_common_area_path(condo, common_area)

    expect(current_path).to eq new_admin_session_path
  end

  it 'e a taxa é negativa' do
    admin = Admin.create!(email: 'ikki.phoenix@seiya.com', password: 'phoenix123')

    condo = FactoryBot.create(:condo)

    FactoryBot.create(:common_area, name: 'TMNT', condo:)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo)
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

  it 'e cancela o registro e volta para show' do
    admin = Admin.create!(email: 'ikki.phoenix@seiya.com', password: 'phoenix123')

    condo = create(:condo)

    common_area = create(:common_area, name: 'TMNT', condo:)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo)
    within 'div#area-0' do
      click_on 'TMNT'
    end
    click_on 'Registrar Taxa'
    click_on 'Cancelar'

    expect(current_path).to eq condo_common_area_path(condo, common_area)
  end
end
