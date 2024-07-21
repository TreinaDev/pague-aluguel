require 'rails_helper'

describe 'Admin visualiza lista de cobranças avulsas' do
  it 'com sucesso - super admin' do
    admin = create(:admin, super_admin: true)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    units = []
    units << unit = Unit.new(id: 1, area: 40, floor: 3, number: '31', unit_type_id: 1)
    units << unit2 = Unit.new(id: 2, area: 40, floor: 3, number: '42', unit_type_id: 1)
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Churrasqueira',
                                   description: 'Área gourmet pra assar carne e batata assada',
                                   max_occupancy: 20, rules: 'Não pode ser vegano', condo_id: 1)
    allow(Condo).to receive(:find).and_return(condo)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).with(1).and_return(unit)
    allow(Unit).to receive(:find).with(2).and_return(unit2)
    allow(CommonArea).to receive(:all).and_return(common_areas)
    single_charge = create(:single_charge, unit_id: unit.id, value_cents: 150_00, issue_date: 5.days.from_now,
                                           description: 'Taxa de pintura', charge_type: 'fine', condo_id: condo.id,
                                           status: 'active')
    single_charge2 = create(:single_charge, unit_id: unit2.id, value_cents: 400_00, issue_date: 7.days.from_now,
                                            description: 'Taxa de pintura', charge_type: 'common_area_fee',
                                            common_area_id: common_areas.first.id, condo_id: condo.id, status: 'active')
    single_charge3 = create(:single_charge, unit_id: unit.id, value_cents: 275_00, issue_date: 10.days.from_now,
                                            description: 'Taxa de pintura', charge_type: 'other', condo_id: condo.id,
                                            status: 'active')

    login_as admin, scope: :admin
    get condo_single_charges_path(condo.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include I18n.t 'activerecord.models.single_charge.other'
    expect(response.body).to include I18n.t 'activerecord.attributes.single_charge.unit_id'
    expect(response.body).to include unit.number
    expect(response.body).to include unit2.number
    expect(response.body).to include I18n.t 'single_charge.fine'
    expect(response.body).to include I18n.t 'single_charge.common_area_fee'
    expect(response.body).to include I18n.t 'single_charge.other'
    expect(response.body).to include single_charge.description
    expect(response.body).to include single_charge2.description
    expect(response.body).to include single_charge3.description
    expect(response.body).to include I18n.t 'activerecord.attributes.single_charge.value'
    expect(response.body).to include single_charge.value.format
    expect(response.body).to include single_charge2.value.format
    expect(response.body).to include single_charge3.value.format
    expect(response.body).to include I18n.t 'activerecord.attributes.single_charge.issue_date'
    expect(response.body).to include I18n.l single_charge.issue_date
    expect(response.body).to include I18n.l single_charge2.issue_date
    expect(response.body).to include I18n.l single_charge3.issue_date
  end

  it 'com sucesso - admin associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    units = []
    units << unit = Unit.new(id: 1, area: 40, floor: 3, number: '31', unit_type_id: 1)
    units << unit2 = Unit.new(id: 2, area: 40, floor: 3, number: '42', unit_type_id: 1)
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Churrasqueira',
                                   description: 'Área gourmet pra assar carne e batata assada',
                                   max_occupancy: 20, rules: 'Não pode ser vegano', condo_id: 1)
    allow(Condo).to receive(:find).and_return(condo)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).with(1).and_return(unit)
    allow(Unit).to receive(:find).with(2).and_return(unit2)
    allow(CommonArea).to receive(:all).and_return(common_areas)
    single_charge = create(:single_charge, unit_id: unit.id, value_cents: 150_00, issue_date: 5.days.from_now,
                                           description: 'Taxa de pintura', charge_type: 'fine', condo_id: condo.id,
                                           status: 'active')
    single_charge2 = create(:single_charge, unit_id: unit2.id, value_cents: 400_00, issue_date: 7.days.from_now,
                                            description: 'Taxa de pintura', charge_type: 'common_area_fee',
                                            common_area_id: common_areas.first.id, condo_id: condo.id, status: 'active')
    single_charge3 = create(:single_charge, unit_id: unit.id, value_cents: 275_00, issue_date: 10.days.from_now,
                                            description: 'Taxa de pintura', charge_type: 'other', condo_id: condo.id,
                                            status: 'active')
    AssociatedCondo.create!(admin:, condo_id: condo.id)

    login_as admin, scope: :admin
    get condo_single_charges_path(condo.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include I18n.t 'activerecord.models.single_charge.other'
    expect(response.body).to include I18n.t 'activerecord.attributes.single_charge.unit_id'
    expect(response.body).to include unit.number
    expect(response.body).to include unit2.number
    expect(response.body).to include I18n.t 'single_charge.fine'
    expect(response.body).to include I18n.t 'single_charge.common_area_fee'
    expect(response.body).to include I18n.t 'single_charge.other'
    expect(response.body).to include single_charge.description
    expect(response.body).to include single_charge2.description
    expect(response.body).to include single_charge3.description
    expect(response.body).to include I18n.t 'activerecord.attributes.single_charge.value'
    expect(response.body).to include single_charge.value.format
    expect(response.body).to include single_charge2.value.format
    expect(response.body).to include single_charge3.value.format
    expect(response.body).to include I18n.t 'activerecord.attributes.single_charge.issue_date'
    expect(response.body).to include I18n.l single_charge.issue_date
    expect(response.body).to include I18n.l single_charge2.issue_date
    expect(response.body).to include I18n.l single_charge3.issue_date
  end

  it 'falha por nao estar associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    units = []
    units << unit = Unit.new(id: 1, area: 40, floor: 3, number: '31', unit_type_id: 1)
    units << unit2 = Unit.new(id: 2, area: 40, floor: 3, number: '42', unit_type_id: 1)
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Churrasqueira',
                                   description: 'Área gourmet pra assar carne e batata assada',
                                   max_occupancy: 20, rules: 'Não pode ser vegano', condo_id: 1)
    allow(Condo).to receive(:find).and_return(condo)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).with(1).and_return(unit)
    allow(Unit).to receive(:find).with(2).and_return(unit2)
    allow(CommonArea).to receive(:all).and_return(common_areas)

    login_as admin, scope: :admin
    get condo_single_charges_path(condo.id)

    expect(response).to have_http_status :found
    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq I18n.t('errors.messages.must_be_super_admin')
  end
end
