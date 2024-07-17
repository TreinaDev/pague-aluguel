require 'rails_helper'

describe 'Admin cancela uma taxa condominial' do
  it 'a partir da tela de detalhes de uma taxa condominial' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    create(:base_fee, name: 'Taxa de Condomínio', condo_id: condos.first.id)
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 222.2, condo_id: 1)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:find_all_by_condo).and_return(unit_types)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    visit root_path
    click_on 'Prédio lindo'
    within 'div#base-fee' do
      click_on 'Ver todas'
    end
    click_on 'Taxa de Condomínio'
    accept_confirm 'Tem certeza que deseja cancelar esse item? Essa ação não poderá ser desfeita.' do
      click_button 'Cancelar'
    end
    base_fee = BaseFee.last

    expect(page).to have_content "#{base_fee.name} cancelada com sucesso"
    expect(base_fee.active?).to eq false
    expect(base_fee.canceled?).to eq true
    expect(current_path).to eq condo_base_fees_path(condos.first.id)
    expect(page).to have_content 'CANCELADA'
  end

  it 'e não vê mais o botão de cancelar' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    create(:base_fee, name: 'Taxa de Condomínio', condo_id: condos.first.id)
    unit_types = []
    unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 222.2, condo_id: 1)
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:find_all_by_condo).and_return(unit_types)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    visit root_path
    click_on 'Prédio lindo'
    within 'div#base-fee' do
      click_on 'Ver todas'
    end
    click_on 'Taxa de Condomínio'
    accept_confirm 'Tem certeza que deseja cancelar esse item? Essa ação não poderá ser desfeita.' do
      click_button 'Cancelar'
    end
    click_on 'Taxa de Condomínio'

    expect(page).to have_content 'CANCELADA'
    expect(page).not_to have_button 'Cancelar'
  end
end
