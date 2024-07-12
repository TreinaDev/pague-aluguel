require 'rails_helper'

describe 'Admin vê lista de taxas cadastradas' do
  it 'e deve estar logado' do
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    allow(Condo).to receive(:find).and_return(condo)

    create(:base_fee, name: 'Taxa de Condomínio', condo_id: 1)
    create(:base_fee, name: 'Taxa de Manutenção', condo_id: 1)
    create(:base_fee, name: 'Taxa de Pintura', condo_id: 1)

    visit condo_base_fees_path(condo.id)

    expect(current_path).to eq new_admin_session_path
  end

  it 'com sucesso' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    allow(Condo).to receive(:find).and_return(condo)

    create(:base_fee, name: 'Taxa de Condomínio', condo_id: 1)
    create(:base_fee, name: 'Taxa de Manutenção', condo_id: 1)
    create(:base_fee, name: 'Taxa de Pintura', condo_id: 1)

    login_as admin, scope: :admin

    visit condo_base_fees_path(condo.id)

    expect(page).to have_link 'Taxa de Condomínio'
    expect(page).to have_link 'Taxa de Manutenção'
    expect(page).to have_link 'Taxa de Pintura'
    expect(page).not_to have_content 'Não existem taxas cadastradas.'
  end

  it 'e não tem taxas cadastradas' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    allow(Condo).to receive(:find).and_return(condo)

    login_as admin, scope: :admin

    visit condo_base_fees_path(condo.id)

    expect(page).to have_content 'Não existem taxas condominiais cadastradas.'
  end

  it 'e retorna para a tela de condomínio' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin

    visit condo_path(condo.id)
    within 'div#base-fee' do
      click_on 'Ver todas'
    end
    find('#arrow-left').click

    expect(current_path).to eq condo_path(condo.id)
  end

  it 'e vê no dashboard de condo as mais recentes' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    common_areas = []
    common_areas << CommonArea.new(id: 3, name: 'Salão de festa',
                                   description: 'Festa para toda a família.',
                                   max_occupancy: 80, rules: 'Não é permitido a entrada de leões')
    allow(CommonArea).to receive(:all).and_return(common_areas)
    allow(Condo).to receive(:find).and_return(condo)
    create(:base_fee, name: 'Taxa de Condomínio', condo_id: 1)
    create(:base_fee, name: 'Taxa de Manutenção', condo_id: 1)
    create(:base_fee, name: 'Taxa de Pintura', condo_id: 1)

    login_as admin, scope: :admin
    visit condo_path(condo.id)
    expect(page).to have_content 'Taxa de Manutenção'
    expect(page).to have_content 'Taxa de Pintura'
    expect(page).to have_content 'recorrência MENSAL'
    expect(page).not_to have_content 'Taxa de Condomínio'
    expect(page).not_to have_content 'Não existem taxas cadastradas.'
  end
end
