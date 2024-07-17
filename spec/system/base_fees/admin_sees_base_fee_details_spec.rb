require 'rails_helper'

describe 'admin vê taxa condominial' do
  it 'e deve estar logado' do
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    base_fee = create(:base_fee)
    allow(Condo).to receive(:find).and_return(condo)

    visit condo_base_fee_path(condo.id, base_fee)

    expect(current_path).to eq new_admin_session_path
  end

  it 'a partir da home page' do
    admin = create(:admin)
    condos = []
    condos << Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    create(:base_fee, name: 'Taxa de Condomínio', condo_id: condos.first.id)
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quarto', metreage: 200, fraction: 2.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 3, description: 'Apartamento 3 quarto', metreage: 300, fraction: 3.0,
                               unit_ids: [])
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(CommonArea).to receive(:all).and_return([])

    login_as admin, scope: :admin
    visit root_path
    click_on 'Prédio lindo'
    within 'div#base-fee' do
      click_on 'Ver todas'
    end
    click_on 'Taxa de Condomínio'

    expect(page).to have_content 'Taxa de Condomínio'
  end

  it 'fixa com sucesso' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [1])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quartos', metreage: 200, fraction: 2.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 3, description: 'Apartamento 3 quartos', metreage: 300, fraction: 3.0,
                               unit_ids: [])
    units = []
    units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
    base_fee = create(:base_fee,
                      name: 'Taxa de Condomínio', description: 'Manutenção.',
                      interest_rate: 2, late_fine: 10, limited: false,
                      charge_day: 25.days.from_now, recurrence: :bimonthly, condo_id: condo.id)
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)

    create(:value, price: 200, unit_type_id: 1, base_fee:)
    create(:value, price: 300, unit_type_id: 2, base_fee:)
    create(:value, price: 500, unit_type_id: 3, base_fee:)

    login_as admin, scope: :admin
    visit condo_base_fee_path(condo.id, base_fee)

    formatted_date = 25.days.from_now.to_date

    expect(page).to have_content 'Taxa de Condomínio'
    expect(page).to have_content 'Manutenção.'
    expect(page).to have_content 'BIMESTRAL'
    expect(page).to have_content 'data de emissão'
    expect(page).to have_content I18n.l(formatted_date).to_s
    expect(page).to have_content "valor para #{unit_types[0].description.downcase}"
    expect(page).to have_content 'R$200,00'
    expect(page).to have_content "valor para #{unit_types[1].description.downcase}"
    expect(page).to have_content 'R$300,00'
    expect(page).to have_content "valor para #{unit_types[2].description.downcase}"
    expect(page).to have_content 'R$500,00'
    expect(page).to have_content 'TAXA FIXA'
    expect(page).not_to have_content 'TAXA LIMITADA'
    expect(page).to have_content 'juros ao dia'
    expect(page).to have_content '2%'
    expect(page).to have_content 'multa por atraso'
    expect(page).to have_content 'R$10,00'
  end

  it 'limitada com sucesso' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [1])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quartos', metreage: 200, fraction: 2.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 3, description: 'Apartamento 3 quartos', metreage: 300, fraction: 3.0,
                               unit_ids: [])
    units = []
    units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
    base_fee = create(:base_fee,
                      name: 'Taxa de Condomínio', description: 'Manutenção.',
                      interest_rate: 2, late_fine: 10, limited: true, installments: 10,
                      charge_day: 25.days.from_now, recurrence: :bimonthly, condo_id: condo.id)
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)

    create(:value, price: 200, unit_type_id: 1, base_fee:)
    create(:value, price: 300, unit_type_id: 2, base_fee:)
    create(:value, price: 500, unit_type_id: 3, base_fee:)

    login_as admin, scope: :admin
    visit condo_base_fee_path(condo.id, base_fee)

    formatted_date = 25.days.from_now.to_date

    expect(page).to have_content 'Taxa de Condomínio'
    expect(page).to have_content 'Manutenção.'
    expect(page).to have_content 'BIMESTRAL'
    expect(page).not_to have_content 'TAXA FIXA'
    expect(page).to have_content 'TAXA LIMITADA'
    expect(page).to have_content "valor para #{unit_types[0].description.downcase}"
    expect(page).to have_content 'R$200,00'
    expect(page).to have_content "valor para #{unit_types[1].description.downcase}"
    expect(page).to have_content 'R$300,00'
    expect(page).to have_content "valor para #{unit_types[2].description.downcase}"
    expect(page).to have_content 'R$500,00'
    expect(page).to have_content '10 x Parcelas'
    expect(page).to have_content 'juros ao dia'
    expect(page).to have_content '2%'
    expect(page).to have_content 'multa por atraso'
    expect(page).to have_content 'R$10,00'
    expect(page).to have_content 'data de emissão'
    expect(page).to have_content I18n.l(formatted_date).to_s
  end

  it 'e retorna para lista de taxas cadastradas' do
    admin = create(:admin)
    condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quartos', metreage: 200, fraction: 2.0,
                               unit_ids: [])
    unit_types << UnitType.new(id: 3, description: 'Apartamento 3 quartos', metreage: 300, fraction: 3.0,
                               unit_ids: [])
    base_fee = create(:base_fee, name: 'Taxa do Condo', condo_id: condo.id)
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(CommonArea).to receive(:all).and_return([])

    create(:value, price: 200, unit_type_id: 1, base_fee:)

    login_as admin, scope: :admin

    visit condo_path(condo.id)
    within 'div#base-fee' do
      click_on 'Ver todas'
    end
    click_on 'Taxa do Condo'
    find('#close').click

    expect(page).not_to have_content 'FIXA'
    expect(page).not_to have_content 'juros ao dia'
    expect(page).not_to have_content '2%'
    expect(page).not_to have_content 'multa por atraso'
    expect(page).not_to have_content 'R$10,00'
  end
end
