# rubocop:disable Metrics/BlockLength
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
                      condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda', tower_name: 'Nard')
    units << Unit.new(id: 2, area: 40, floor: 1, number: '12', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda', tower_name: 'Dog')
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
    expect(page).to have_content 'andar: 1'
    expect(page).to have_content 'Unidade 11'
    expect(page).to have_content 'Unidade 12'
    expect(page).to have_content 'torre: nard'
    expect(page).to have_content 'torre: dog'
  end

  it 'e gera com sucesso' do
    freeze_time do
      admin = create(:admin)
      condos = []
      condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
      condos << condo
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                                 unit_ids: [])
      units = []
      units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda', tower_name: 'Beta')
      units << Unit.new(id: 2, area: 40, floor: 1, number: '12', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda', tower_name: 'Alpha')
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condo)
      allow(CommonArea).to receive(:all).and_return([])
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)
      create(:bill, unit_id: 1, condo_id: 1, status: :paid)

      login_as admin, scope: :admin
      visit condo_path(condo.id)
      within('div#nd_certificate_section') do
        click_on 'Ver todas as unidades'
      end
      within('div#unit_1') do
        click_on 'Emitir Certificado'
      end

      expect(page).to have_content 'Certidão de quitação emitida com sucesso'
      expect(page).to have_content I18n.l(Time.zone.now)
      expect(current_path).to eq certificate_condo_nd_certificate_path(condo_id: condo.id, id: 1)
      expect(page).to have_content 'Condomínio: Condomínio Vila das Flores'
      expect(page).to have_content 'Unidade: 11'
    end
  end

  it 'e falha pois possui débitos pendentes' do
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
    allow(Unit).to receive(:find).and_return(units.first)
    create(:bill, unit_id: 1, condo_id: 1, status: :pending)
    create(:bill, unit_id: 1, condo_id: 1, status: :paid)

    login_as admin, scope: :admin
    visit condo_path(condo.id)
    within('div#nd_certificate_section') do
      click_on 'Ver todas as unidades'
    end
    within('div#unit_1') do
      click_on 'Emitir Certificado'
    end

    expect(page).to have_content 'Esta unidade possui débitos pendentes.'
  end
end

# rubocop:enable Metrics/BlockLength
