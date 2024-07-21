require 'rails_helper'

describe 'Admin visualiza detalhes de uma cobrança avulsa' do
  it 'com sucesso - super admin' do
    admin = create(:admin, super_admin: true)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit = Unit.new(id: 1, area: 40, floor: 3, number: '31', unit_type_id: 1)
    units = [unit]
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Churrasqueira',
                                   description: 'Área gourmet pra assar carne e batata assada',
                                   max_occupancy: 20, rules: 'Não pode ser vegano', condo_id: 1)
    allow(Condo).to receive(:find).and_return(condo)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).and_return(unit)
    allow(CommonArea).to receive(:all).and_return(common_areas)
    single_charge = create(:single_charge, unit_id: unit.id, value_cents: 150_00, issue_date: 5.days.from_now,
                                           description: 'Taxa de pintura', charge_type: 'fine', condo_id: condo.id,
                                           status: 'active')

    login_as admin, scope: :admin
    get condo_single_charge_path(condo.id, single_charge.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Cobrança Avulsa'
    expect(response.body).to include 'Unidade'
    expect(response.body).to include unit.number
    expect(response.body).to include 'Tipo de Cobrança'
    expect(response.body).to include 'Multa'
    expect(response.body).to include single_charge.description
    expect(response.body).to include 'Valor Total'
    expect(response.body).to include single_charge.value.format
    expect(response.body).to include 'Data de Emissão'
  end

  it 'com sucesso - admin associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit = Unit.new(id: 1, area: 40, floor: 3, number: '31', unit_type_id: 1)
    units = [unit]
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Churrasqueira',
                                   description: 'Área gourmet pra assar carne e batata assada',
                                   max_occupancy: 20, rules: 'Não pode ser vegano', condo_id: 1)
    allow(Condo).to receive(:find).and_return(condo)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).and_return(unit)
    allow(CommonArea).to receive(:all).and_return(common_areas)
    single_charge = create(:single_charge, unit_id: unit.id, value_cents: 150_00, issue_date: 5.days.from_now,
                                           description: 'Taxa de pintura', charge_type: 'fine', condo_id: condo.id,
                                           status: 'active')
    AssociatedCondo.create!(admin:, condo_id: condo.id)

    login_as admin, scope: :admin
    get condo_single_charge_path(condo.id, single_charge.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Cobrança Avulsa'
    expect(response.body).to include 'Unidade'
    expect(response.body).to include unit.number
    expect(response.body).to include 'Tipo de Cobrança'
    expect(response.body).to include 'Multa'
    expect(response.body).to include single_charge.description
    expect(response.body).to include 'Valor Total'
    expect(response.body).to include single_charge.value.format
    expect(response.body).to include 'Data de Emissão'
  end

  it 'falha por nao estar associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit = Unit.new(id: 1, area: 40, floor: 3, number: '31', unit_type_id: 1)
    units = [unit]
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Churrasqueira',
                                   description: 'Área gourmet pra assar carne e batata assada',
                                   max_occupancy: 20, rules: 'Não pode ser vegano', condo_id: 1)
    allow(Condo).to receive(:find).and_return(condo)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).and_return(unit)
    allow(CommonArea).to receive(:all).and_return(common_areas)
    single_charge = create(:single_charge, unit_id: unit.id, value_cents: 150_00, issue_date: 5.days.from_now,
                                           description: 'Taxa de pintura', charge_type: 'fine', condo_id: condo.id,
                                           status: 'active')

    login_as admin, scope: :admin
    get condo_single_charge_path(condo.id, single_charge.id)

    expect(response).to have_http_status :found
    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq 'Você não tem autorização para completar esta ação.'
  end
end
