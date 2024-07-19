require 'rails_helper'

describe 'Admin cria contas compartilhadas' do
  it 'com sucesso - super admin' do
    admin = create(:admin, super_admin: true)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [1])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quarto', metreage: 200, fraction: 2.0,
                               unit_ids: [2])
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)

    login_as admin, scope: :admin
    post(condo_shared_fees_path(condo.id), params: { shared_fee: { description: 'Descrição',
                                                                   issue_date: 10.days.from_now.to_date,
                                                                   total_value: 1000 } })

    expect(response).to have_http_status :found
    expect(response).to redirect_to condo_path(condo.id)
    expect(SharedFee.count).to eq 1
    expect(SharedFee.last.shared_fee_fractions.length).to eq 2
    expect(SharedFee.last.description).to eq 'Descrição'
    expect(SharedFee.last.issue_date).to eq 10.days.from_now.to_date
    expect(SharedFee.last.total_value_cents).to eq 100_000
  end

  it 'com sucesso - admin associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [1])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quarto', metreage: 200, fraction: 2.0,
                               unit_ids: [2])
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)
    AssociatedCondo.create!(admin:, condo_id: condo.id)

    login_as admin, scope: :admin
    post(condo_shared_fees_path(condo.id), params: { shared_fee: { description: 'Descrição',
                                                                   issue_date: 10.days.from_now.to_date,
                                                                   total_value: 1000 } })

    expect(response).to have_http_status :found
    expect(response).to redirect_to condo_path(condo.id)
    expect(SharedFee.count).to eq 1
    expect(SharedFee.last.shared_fee_fractions.length).to eq 2
    expect(SharedFee.last.description).to eq 'Descrição'
    expect(SharedFee.last.issue_date).to eq 10.days.from_now.to_date
    expect(SharedFee.last.total_value_cents).to eq 100_000
  end

  it 'falha por nao estar associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [1])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quarto', metreage: 200, fraction: 2.0,
                               unit_ids: [2])
    units = []
    units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
    units << Unit.new(id: 2, area: 100, floor: 1, number: 1, unit_type_id: 2)
    allow(Unit).to receive(:all).and_return(units)
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return(unit_types)

    login_as admin, scope: :admin
    post(condo_shared_fees_path(condo.id), params: { shared_fee: { description: 'Descrição',
                                                                   issue_date: 10.days.from_now.to_date,
                                                                   total_value_cents: 1000 } })

    expect(SharedFee.count).to eq 0
    expect(response).to have_http_status :found
    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq I18n.t('errors.messages.must_be_super_admin')
  end
end
