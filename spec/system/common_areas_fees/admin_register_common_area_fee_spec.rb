require 'rails_helper'

describe 'Admin registra uma taxa de área comum' do
  it 'com sucesso a partir da listagem de área comum' do
    admin = create(:admin)

    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    create(:common_area, name: 'TMNT', condo_id: condo.id)
    allow(Condo).to receive(:find).and_return(condo)

    create(:common_area, fee: '300,00', condo_id: condo.id)

    login_as admin, scope: :admin
    visit condo_path(condo.id)
    within 'div#common-areas' do
      click_on 'TMNT'
    end
    find('#edit-common-area').click
    fill_in 'Taxa de área comum', with: '200,50'
    click_on 'ATUALIZAR'

    expect(page).to have_content 'Taxa de área comum'
    expect(page).to have_content 'R$200,50'
    expect(page).not_to have_content 'R$300,00'
    expect(current_path).to eq condo_path(condo.id)
  end

  it 'se estiver autenticado' do
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    common_area = create(:common_area, condo_id: condo.id)

    visit edit_condo_common_area_path(condo.id, common_area)

    expect(current_path).to eq new_admin_session_path
  end

  it 'e a taxa é nula' do
    admin = create(:admin)

    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    create(:common_area, name: 'TMNT', condo_id: condo.id)

    login_as admin, scope: :admin
    visit condo_path(condo.id)
    within 'div#common-areas' do
      click_on 'TMNT'
    end
    find('#edit-common-area').click
    fill_in 'Taxa de área comum', with: ''
    click_on 'ATUALIZAR'

    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Taxa de área comum não é um número'
  end

  it 'e cancela o registro e volta para show' do
    admin = create(:admin)

    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    create(:common_area, name: 'TMNT', condo_id: condo.id)

    login_as admin, scope: :admin
    visit condo_path(condo.id)
    within 'div#common-areas' do
      click_on 'TMNT'
    end
    find('#edit-common-area').click
    fill_in 'Taxa de área comum', with: ''
    click_on 'CANCELAR'

    expect(current_path).to eq condo_path(condo.id)
  end
end
