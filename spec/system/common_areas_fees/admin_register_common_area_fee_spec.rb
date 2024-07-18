require 'rails_helper'

describe 'Admin registra uma taxa de área comum' do
  it 'com sucesso a partir da listagem de área comum' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Teenage Mutant Ninja Turtles', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    common_areas = []
    common_areas << CommonArea.new(id: 3, name: 'Academia',
                                   description: 'Uma academia raíz com ventilador apenas para os marombas')
    common_area = CommonArea.new(id: 3, name: 'Academia',
                                 description: 'Uma academia raíz com ventilador apenas para os marombas',
                                 max_occupancy: 20, rules: 'Não pode ser frango')
    allow(CommonArea).to receive(:all).with(1).and_return(common_areas)
    allow(CommonArea).to receive(:find).with('3').and_return(common_area)

    login_as admin, scope: :admin
    visit condo_path(condo.id)
    within 'div#common-areas' do
      click_on 'Academia'
    end
    find('#new-common-area').click
    fill_in 'Taxa', with: '200,50'
    click_on 'Atualizar'

    expect(page).to have_content 'Taxa de área comum'
    expect(page).to have_content 'Taxa cadastrada com sucesso!'
    expect(page).to have_content 'R$200,50'
    expect(current_path).to eq condo_path(condo.id)
  end

  it 'se estiver autenticado' do
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    common_areas = []
    common_areas << CommonArea.new(id: 3, name: 'Academia',
                                   description: 'Uma academia raíz com ventilador apenas para os marombas')
    common_area = CommonArea.new(id: 3, name: 'Academia',
                                 description: 'Uma academia raíz com ventilador apenas para os marombas',
                                 max_occupancy: 20, rules: 'Não pode ser frango')
    allow(CommonArea).to receive(:all).with(1).and_return(common_areas)
    allow(CommonArea).to receive(:find).with('3').and_return(common_area)

    visit new_condo_common_area_common_area_fee_path(condo.id, common_area.id)

    expect(current_path).to eq new_admin_session_path
  end

  it 'e deixa em branco' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    common_areas = []
    common_areas << CommonArea.new(id: 3, name: 'Academia',
                                   description: 'Uma academia raíz com ventilador apenas para os marombas')
    common_area = CommonArea.new(id: 3, name: 'Academia',
                                 description: 'Uma academia raíz com ventilador apenas para os marombas',
                                 max_occupancy: 20, rules: 'Não pode ser frango')
    allow(CommonArea).to receive(:all).with(1).and_return(common_areas)
    allow(CommonArea).to receive(:find).with('3').and_return(common_area)

    login_as admin, scope: :admin
    visit condo_path(condo.id)
    within 'div#common-areas' do
      click_on 'Academia'
    end
    find('#new-common-area').click
    fill_in 'Taxa', with: ''
    click_on 'Atualizar'

    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Taxa não é um número'
  end

  it 'e cancela o registro e volta para show' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Teenage Mutant Ninja Turtles', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    common_areas = []
    common_areas << CommonArea.new(id: 3, name: 'Academia',
                                   description: 'Uma academia raíz com ventilador apenas para os marombas')
    common_area = CommonArea.new(id: 3, name: 'Academia',
                                 description: 'Uma academia raíz com ventilador apenas para os marombas',
                                 max_occupancy: 20, rules: 'Não pode ser frango')
    allow(CommonArea).to receive(:all).with(1).and_return(common_areas)
    allow(CommonArea).to receive(:find).with('3').and_return(common_area)

    login_as admin, scope: :admin
    visit condo_path(condo.id)
    within 'div#common-areas' do
      click_on 'Academia'
    end
    find('#new-common-area').click
    click_on 'Cancelar'

    expect(current_path).to eq condo_path(condo.id)
  end
end
