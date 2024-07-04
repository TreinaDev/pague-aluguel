require 'rails_helper'

describe 'Admin vê área comum' do
  it 'com sucesso' do
    admin = create(:admin, email: 'ikki.phoenix@seiya.com', password: 'phoenix123')
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)
    CommonArea.create!(name: 'TMNT', description: 'Teenage Mutant Ninja Turtles', max_capacity: 40,
                       usage_rules: 'Não lutar no salão', fee_cents: 200_00, condo_id: condo.id)

    login_as admin, scope: :admin
    visit condo_common_areas_path(condo.id)
    within 'div#area-0' do
      click_on 'TMNT'
    end

    expect(page).to have_content 'TMNT'
    expect(page).to have_content 'Teenage Mutant Ninja Turtles'
    expect(page).to have_content 'capacidade máxima 40 pessoas'
    expect(page).to have_content 'regras de uso Não lutar no salão'
    expect(page).to have_content 'Taxa de área comum'
    expect(page).to have_content 'R$200,00'
  end

  it 'e taxa não está cadastrada' do
    admin = create(:admin, email: 'ikki.phoenix@seiya.com', password: 'phoenix123')
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)
    common_area = FactoryBot.create(:common_area, fee_cents: 0, condo_id: condo.id)

    login_as admin, scope: :admin
    visit condo_common_area_path(condo.id, common_area)

    expect(page).to have_content 'Taxa não cadastrada'
  end

  it 'e vê histórico de taxas' do
    admin = create(:admin, email: 'ikki.phoenix@seiya.com', password: 'phoenix123')
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)
    FactoryBot.create(:common_area, name: 'Salão de Festas', fee_cents: 0, condo_id: condo.id)

    login_as admin, scope: :admin

    visit condo_path(condo.id)
    within 'div#common-areas' do
      click_on 'Salão de Festas'
    end
    find('#edit-common-area').click
    fill_in 'Taxa de área comum', with: '200,00'
    click_on 'ATUALIZAR'
    travel 1.month
    find('#edit-common-area').click
    fill_in 'Taxa de área comum', with: '300,00'
    click_on 'ATUALIZAR'
    click_on 'Mostrar histórico de taxas'

    expect(page).to have_content 'ikki.phoenix@seiya.com'
    expect(page).to have_content 'R$200,00'
    expect(page).to have_content 1.month.ago.strftime('%d/%m/%Y')
    expect(page).to have_content 'R$300,00'
    expect(page).to have_content Time.zone.today.strftime('%d/%m/%Y')
  end

  it 'e o histórico de taxas não existe' do
    admin = create(:admin, email: 'ikki.phoenix@seiya.com', password: 'phoenix123')
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)
    common_area = FactoryBot.create(:common_area, fee_cents: 0, condo_id: condo.id)

    login_as admin, scope: :admin
    visit condo_common_area_path(condo.id, common_area)

    expect(page).not_to have_link 'Mostrar histórico de taxas'
  end
end
