require 'rails_helper'

describe 'Admin cria taxa condominial' do
  it 'com sucesso' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: true)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return([])

    login_as admin, scope: :admin
    get new_condo_base_fee_path(condo.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Cadastro'
    expect(response.body).to include 'Condo Test'
    expect(response.body).to include I18n.t 'activerecord.attributes.base_fee.name'
    expect(response.body).to include I18n.t 'activerecord.attributes.base_fee.description'
    expect(response.body).to include I18n.t 'activerecord.attributes.base_fee.interest_rate'
    expect(response.body).to include I18n.t 'activerecord.attributes.base_fee.late_fine'
    expect(response.body).to include I18n.t 'activerecord.attributes.base_fee.charge_day'
    expect(response.body).to include I18n.t 'activerecord.attributes.base_fee.limited'
    expect(response.body).to include I18n.t 'activerecord.attributes.base_fee.installments'
    expect(response.body).to include I18n.t 'activerecord.attributes.base_fee.recurrence'
  end

  it 'com sucesso - Admin com acesso' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')

    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return([])
    AssociatedCondo.create(admin:, condo_id: condo.id)

    login_as admin, scope: :admin
    get new_condo_base_fee_path(condo.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Cadastro'
    expect(response.body).to include 'Condo Test'
    expect(response.body).to include I18n.t 'activerecord.attributes.base_fee.name'
    expect(response.body).to include I18n.t 'activerecord.attributes.base_fee.description'
    expect(response.body).to include I18n.t 'activerecord.attributes.base_fee.interest_rate'
    expect(response.body).to include I18n.t 'activerecord.attributes.base_fee.late_fine'
    expect(response.body).to include I18n.t 'activerecord.attributes.base_fee.charge_day'
    expect(response.body).to include I18n.t 'activerecord.attributes.base_fee.limited'
    expect(response.body).to include I18n.t 'activerecord.attributes.base_fee.installments'
    expect(response.body).to include I18n.t 'activerecord.attributes.base_fee.recurrence'
  end

  it 'falha pois não está associado' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')

    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return([])

    login_as admin, scope: :admin
    get new_condo_base_fee_path(condo.id)

    expect(response).to have_http_status :found
    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq I18n.t('errors.messages.must_be_super_admin')
  end
end
