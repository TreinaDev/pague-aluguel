require 'rails_helper'

describe 'Admin acessa pagina de nova conta compartilhada' do
  it 'com sucesso - super admin' do
    admin = create(:admin, super_admin: true)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:find).and_return(condo)

    login_as admin, scope: :admin
    get new_condo_shared_fee_path(condo.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include('Condo Test')
    expect(response.body).to include('Descrição')
    expect(response.body).to include('Data de Emissão')
    expect(response.body).to include('Valor Total')
  end

  it 'com sucesso - admin esta associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:find).and_return(condo)
    AssociatedCondo.create!(admin_id: admin.id, condo_id: condo.id)

    login_as admin, scope: :admin
    get new_condo_shared_fee_path(condo.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include('Condo Test')
    expect(response.body).to include('Descrição')
    expect(response.body).to include('Data de Emissão')
    expect(response.body).to include('Valor Total')
  end

  it 'falha - nao esta associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:find).and_return(condo)

    login_as admin, scope: :admin
    get new_condo_shared_fee_path(condo.id)

    expect(response).to have_http_status :found
    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq I18n.t('errors.messages.must_be_super_admin')
  end

  it 'e não está autenticado' do
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')

    get new_condo_shared_fee_path(condo.id)

    expect(response).to have_http_status :found
    expect(response).to redirect_to(new_admin_session_path)
  end
end
