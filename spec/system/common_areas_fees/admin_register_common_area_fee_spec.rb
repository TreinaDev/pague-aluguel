require 'rails_helper'

describe 'Admin registra uma taxa de área comum' do
  it 'com sucesso a partir da listagem de área comum' do
    admin = create(:admin)

    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    common_area = create(:common_area, name: 'TMNT', condo_id: condo.id)
    allow(Condo).to receive(:find).and_return(condo)

    create(:common_area, condo_id: condo.id)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo.id)
    within 'div#area-0' do
      click_on 'TMNT'
    end
    click_on 'Registrar Taxa'
    fill_in 'Taxa de área comum', with: '200,50'
    click_on 'Atualizar'
    sleep 0.2

    expect(current_path).to eq condo_common_area_path(condo.id, common_area)
    expect(page).to have_content 'Taxa de área comum: R$200,50'
    expect(page).to have_content 'Taxa cadastrada com sucesso!'
  end

  it 'se estiver autenticado' do
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    common_area = create(:common_area, condo_id: condo.id)

    visit edit_condo_common_area_path(condo.id, common_area)

    expect(current_path).to eq new_admin_session_path
  end

  it 'e a taxa é negativa' do
    admin = create(:admin)

    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    create(:common_area, name: 'TMNT', condo_id: condo.id)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo)
    within 'div#area-0' do
      click_on 'TMNT'
    end
    click_on 'Registrar Taxa'
    fill_in 'Taxa de área comum', with: ''
    click_on 'Atualizar'

    expect(page).to have_content 'Não foi possível registrar a taxa.'
    expect(page).to have_content 'Atente-se aos erros abaixo:'
    expect(page).to have_content 'Taxa de área comum não é um número'
  end

  it 'e cancela o registro e volta para show' do
    admin = create(:admin)

    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    common_area = create(:common_area, name: 'TMNT', condo_id: condo.id)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo.id)
    within 'div#area-0' do
      click_on 'TMNT'
    end
    click_on 'Registrar Taxa'
    click_on 'Cancelar'

    expect(current_path).to eq condo_common_area_path(condo.id, common_area)
  end
end
