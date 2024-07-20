require 'rails_helper'

describe 'Admin acessa detalhes de conta compartilhada' do
  it 'com sucesso - super admin' do
    admin = create(:admin, super_admin: true)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:find).and_return(condo)

    shared_fee = SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                                   total_value: 10_000, condo_id: condo.id)

    login_as admin, scope: :admin
    get condo_shared_fee_path(condo.id, shared_fee.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include('Conta de Luz')
    expect(response.body).to include('10.000,00')
    expect(response.body).to include(I18n.l(10.days.from_now.to_date))
  end

  it 'com sucesso - admin associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:find).and_return(condo)
    AssociatedCondo.create!(admin_id: admin.id, condo_id: condo.id)

    shared_fee = SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                                   total_value: 10_000, condo_id: condo.id)

    login_as admin, scope: :admin
    get condo_shared_fee_path(condo.id, shared_fee.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include('Conta de Luz')
    expect(response.body).to include('10.000,00')
    expect(response.body).to include(I18n.l(10.days.from_now.to_date))
  end

  it 'falha - nao esta associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:find).and_return(condo)

    shared_fee = SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                                   total_value: 10_000, condo_id: condo.id)

    login_as admin, scope: :admin
    get condo_shared_fee_path(condo.id, shared_fee.id)

    expect(response).to have_http_status :found
    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq I18n.t('errors.messages.must_be_super_admin')
    expect(response.body).not_to include('Conta de Luz')
    expect(response.body).not_to include('10.000,00')
    expect(response.body).not_to include(I18n.l(10.days.from_now.to_date))
  end

  it 'e não está autenticado' do
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:find).and_return(condo)

    shared_fee = SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                                   total_value: 10_000, condo_id: condo.id)

    get condo_shared_fee_path(condo.id, shared_fee.id)

    expect(response).to have_http_status :found
    expect(response).to redirect_to(new_admin_session_path)
  end
end
