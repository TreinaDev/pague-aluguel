require 'rails_helper'

describe 'Admin visualiza lista de contas compartilhadas' do
  it 'com sucesso - super admin' do
    admin = create(:admin, super_admin: true)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [1])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quarto', metreage: 200, fraction: 2.0,
                               unit_ids: [2])
    allow(Condo).to receive(:find).and_return(condo)
    create(:shared_fee, description: 'Primeira descrição', total_value_cents: 200_00,
                        issue_date: 10.days.from_now.to_date, condo_id: condo.id)
    create(:shared_fee, description: 'Segunda descrição', total_value_cents: 300_00,
                        issue_date: 10.days.from_now.to_date, condo_id: condo.id)

    login_as admin, scope: :admin
    get condo_shared_fees_path(condo.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Contas Compartilhadas'
    expect(response.body).to include 'Condo Test'
    expect(response.body).to include 'Primeira descrição'
    expect(response.body).to include 'Valor Total'
    expect(response.body).to include 'R$200,00'
    expect(response.body).to include 'Segunda descrição'
    expect(response.body).to include 'R$300,00'
    expect(response.body).to include 'Data de Emissão'
    expect(response.body).to include I18n.l(10.days.from_now.to_date)
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
    create(:shared_fee, description: 'Primeira descrição', total_value_cents: 200_00,
                        issue_date: 10.days.from_now.to_date, condo_id: condo.id)
    create(:shared_fee, description: 'Segunda descrição', total_value_cents: 300_00,
                        issue_date: 10.days.from_now.to_date, condo_id: condo.id)
    AssociatedCondo.create!(admin:, condo_id: condo.id)

    login_as admin, scope: :admin
    get condo_shared_fees_path(condo.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Contas Compartilhadas'
    expect(response.body).to include 'Condo Test'
    expect(response.body).to include 'Primeira descrição'
    expect(response.body).to include 'Valor Total'
    expect(response.body).to include 'R$200,00'
    expect(response.body).to include 'Segunda descrição'
    expect(response.body).to include 'R$300,00'
    expect(response.body).to include 'Data de Emissão'
    expect(response.body).to include I18n.l(10.days.from_now.to_date)
  end

  it 'falha por nao estar associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                               unit_ids: [1])
    unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quarto', metreage: 200, fraction: 2.0,
                               unit_ids: [2])
    allow(Condo).to receive(:find).and_return(condo)
    create(:shared_fee, description: 'Primeira descrição', total_value_cents: 200_00,
                        issue_date: 10.days.from_now.to_date, condo_id: condo.id)
    create(:shared_fee, description: 'Segunda descrição', total_value_cents: 300_00,
                        issue_date: 10.days.from_now.to_date, condo_id: condo.id)

    login_as admin, scope: :admin
    get condo_shared_fees_path(condo.id)

    expect(response).to have_http_status :found
    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq I18n.t('errors.messages.must_be_super_admin')
  end
end
