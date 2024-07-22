require 'rails_helper'

describe 'Admin vê área comum' do
  it 'com sucesso' do
    admin = create(:admin, email: 'ikki.phoenix@seiya.com', password: 'phoenix123')
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    common_areas = []
    common_areas << CommonArea.new(id: 3, name: 'Salão de festa',
                                   description: 'Salão preparado para grandes festas')
    common_area = CommonArea.new(id: 3, name: 'Salão de festa',
                                 description: 'Salão preparado para grandes festas',
                                 max_occupancy: 80, rules: 'Som alto somente até as 22h')
    allow(CommonArea).to receive(:all).with(1).and_return(common_areas)
    allow(CommonArea).to receive(:find).with('3').and_return(common_area)

    create(:common_area_fee, value_cents: 200_00, admin:, common_area_id: 3, condo_id: condo.id)

    login_as admin, scope: :admin
    visit condo_path(condo.id)
    within 'div#common-areas' do
      click_on 'Salão de festa'
    end

    expect(page).to have_content 'Salão de festa'
    expect(page).to have_content 'Salão preparado para grandes festas'
    expect(page).to have_content 'Som alto somente até as 22h'
    expect(page).to have_content '80 pessoas'
    expect(page).to have_content 'regras de uso'
    expect(page).to have_content 'Taxa de área comum'
    expect(page).to have_content 'R$200,00'
  end

  it 'e taxa não está cadastrada' do
    admin = create(:admin, email: 'ikki.phoenix@seiya.com', password: 'phoenix123')
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
    visit condo_common_area_path(condo.id, common_area.id)

    expect(page).to have_content 'Taxa não cadastrada'
    expect(page).not_to have_link 'Mostrar histórico de taxas'
  end

  it 'e vê histórico de taxas' do
    admin = create(:admin, email: 'ikki.phoenix@seiya.com', password: 'phoenix123')
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    common_areas = []
    common_areas << CommonArea.new(id: 3, name: 'Salão de festa',
                                   description: 'Salão preparado para grandes festas')
    common_area = CommonArea.new(id: 3, name: 'Salão de festa',
                                 description: 'Salão preparado para grandes festas',
                                 max_occupancy: 80, rules: 'Som alto somente até as 22h')
    allow(CommonArea).to receive(:all).with(1).and_return(common_areas)
    allow(CommonArea).to receive(:find).with('3').and_return(common_area)

    login_as admin, scope: :admin

    visit condo_path(condo.id)
    within 'div#common-areas' do
      click_on 'Salão de festa'
    end
    find('#new-common-area').click
    fill_in 'Taxa', with: '200,00'
    click_on 'Atualizar'
    travel 1.month
    find('#new-common-area').click
    fill_in 'Taxa', with: '300,00'
    click_on 'Atualizar'
    click_on 'Mostrar histórico de taxas'

    expect(page).to have_content 'ikki.phoenix@seiya.com'
    expect(page).to have_content 'R$200,00'
    expect(page).to have_content 1.month.ago.strftime('%d/%m/%Y')
    expect(page).to have_content 'R$300,00'
    expect(page).to have_content Time.zone.today.strftime('%d/%m/%Y')
  end

  it 'tenta acessar área comum que não existe' do
    admin = create(:admin, email: 'ikki.phoenix@seiya.com', password: 'phoenix123')
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:all).with(1).and_return([])
    allow(CommonArea).to receive(:find).and_raise(StandardError)

    login_as admin, scope: :admin
    visit condo_common_area_path(condo.id, 55)

    expect(page).to have_content 'Nenhuma área comum encontrada.'
    expect(current_path).to eq condo_path(condo.id)
  end

  it 'tenta acessar área em condomínio que não existe' do
    admin = create(:admin, email: 'ikki.phoenix@seiya.com', password: 'phoenix123')
    allow(Condo).to receive(:all).and_return([])
    allow(Condo).to receive(:find).and_raise(StandardError)

    login_as admin, scope: :admin
    visit condo_common_area_path(55, 55)

    expect(page).to have_content 'Nenhum condomínio encontrado.'
    expect(current_path).to eq root_path
  end
end
