require 'rails_helper'

describe 'Admin visualiza lista de cobranças avulsas' do
  it 'com sucesso - super admin' do
    admin = create(:admin, super_admin: true)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    units = []
    units << unit = Unit.new(id: 1, area: 40, floor: 3, number: '31', unit_type_id: 1)
    common_areas = []
    allow(Condo).to receive(:find).and_return(condo)
    allow(Unit).to receive(:all).and_return(units)
    allow(CommonArea).to receive(:all).and_return(common_areas)
    single_charge = create(:single_charge, unit_id: unit.id, value_cents: 150_00, issue_date: 5.days.from_now,
                                           description: 'Taxa de pintura', charge_type: 'fine', condo_id: condo.id,
                                           status: 'active')

    login_as admin, scope: :admin
    post cancel_condo_single_charge_path(condo.id, single_charge.id)

    expect(SingleCharge.first).to be_canceled
    expect(response).to have_http_status :found
    expect(response).to redirect_to condo_single_charges_path(condo.id)
  end

  it 'com sucesso - admin associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    units = []
    units << unit = Unit.new(id: 1, area: 40, floor: 3, number: '31', unit_type_id: 1)
    common_areas = []
    allow(Condo).to receive(:find).and_return(condo)
    allow(Unit).to receive(:all).and_return(units)
    allow(CommonArea).to receive(:all).and_return(common_areas)
    single_charge = create(:single_charge, unit_id: unit.id, value_cents: 150_00, issue_date: 5.days.from_now,
                                           description: 'Taxa de pintura', charge_type: 'fine', condo_id: condo.id,
                                           status: 'active')
    AssociatedCondo.create!(admin:, condo_id: condo.id)

    login_as admin, scope: :admin
    post cancel_condo_single_charge_path(condo.id, single_charge.id)

    expect(SingleCharge.first).to be_canceled
    expect(response).to have_http_status :found
    expect(response).to redirect_to condo_single_charges_path(condo.id)
  end

  it 'falha por nao estar associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    units = []
    units << unit = Unit.new(id: 1, area: 40, floor: 3, number: '31', unit_type_id: 1)
    common_areas = []
    allow(Condo).to receive(:find).and_return(condo)
    allow(Unit).to receive(:all).and_return(units)
    allow(CommonArea).to receive(:all).and_return(common_areas)
    single_charge = create(:single_charge, unit_id: unit.id, value_cents: 150_00, issue_date: 5.days.from_now,
                                           description: 'Taxa de pintura', charge_type: 'fine', condo_id: condo.id,
                                           status: 'active')

    login_as admin, scope: :admin
    post cancel_condo_single_charge_path(condo.id, single_charge.id)

    expect(response).to have_http_status :found
    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq I18n.t('errors.messages.must_be_super_admin')
  end
end
