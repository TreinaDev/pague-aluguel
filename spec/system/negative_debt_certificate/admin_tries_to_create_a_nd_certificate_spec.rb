require 'rails_helper'

describe 'Admin tenta emitir certificado de debito negativo' do
  it 'e vê com sucesso listagem de unidades' do
    admin = create(:admin)
    condos = []
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    condos << condo
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                               unit_ids: [])
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    units << Unit.new(id: 2, area: 40, floor: 1, number: '12', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:all).and_return([])
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).with(1).and_return(units.first)
    allow(Unit).to receive(:find).with(2).and_return(units.second)

    login_as admin, scope: :admin
    visit condo_path(condo.id)
    within('div#nd_certificate_section') do
      click_on 'Ver todas as unidades'
    end

    expect(page).to have_content 'UNIDADES'
    expect(page).to have_content 'Condomínio Vila das Flores'.upcase
    expect(page).to have_content 'Andar : 1'
    expect(page).to have_content 'Número 11'
    expect(page).to have_content 'Número 12'
  end

  it 'e cadastra gera com sucesso' do
    admin = create(:admin)
    condos = []
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    condos << condo
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                               unit_ids: [])
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    units << Unit.new(id: 2, area: 40, floor: 1, number: '12', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:all).and_return([])
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).with(1).and_return(units.first)
    allow(Unit).to receive(:find).with(2).and_return(units.second)

    login_as admin, scope: :admin
    visit condo_path(condo.id)
    within('div#nd_certificate_section') do
      click_on 'Ver todas as unidades'
    end
    click_on 'Número 11'
    click_on 'Emitir Certificado de Débito Negativo'

    expect(page).to have_content 'Certificado de Débito Negativo'
  end
end
