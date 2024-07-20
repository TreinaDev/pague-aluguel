require 'rails_helper'

describe 'Admin acessa lista de taxas condominiais' do
  it 'com sucesso - super admin' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: true)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:find).and_return(condo)
    create(:base_fee, name: 'Fundo de Reserva', description: 'Destinado a cobrir despesas imprevistas',
                      recurrence: :monthly, charge_day: 10.days.from_now, condo_id: condo.id)
    create(:base_fee, name: 'Jardinagem', description: 'Cuidar das arvores do condomínio',
                      recurrence: :bimonthly, condo_id: condo.id)

    login_as admin, scope: :admin
    get condo_base_fees_path(condo.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Listagem de Taxas Condominiais'
    expect(response.body).to include 'Condo Test'
    expect(response.body).to include 'TODAS AS TAXAS'
    expect(response.body).to include 'Fundo de Reserva'
    expect(response.body).to include 'Destinado a cobrir despesas imprevistas'
    expect(response.body).to include 'Recorrência'
    expect(response.body).to include 'Mensal'
    expect(response.body).to include 'Jardinagem'
    expect(response.body).to include 'Cuidar das arvores do condomínio'
    expect(response.body).to include 'Bimestral'
  end

  it 'com sucesso - Admin com acesso' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:find).and_return(condo)
    create(:base_fee, name: 'Fundo de Reserva', description: 'Destinado a cobrir despesas imprevistas',
                      recurrence: :monthly, charge_day: 10.days.from_now, condo_id: condo.id)
    create(:base_fee, name: 'Jardinagem', description: 'Cuidar das arvores do condomínio',
                      recurrence: :bimonthly, condo_id: condo.id)
    AssociatedCondo.create(admin_id: admin.id, condo_id: condo.id)

    login_as admin, scope: :admin
    get condo_base_fees_path(condo.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Listagem de Taxas Condominiais'
    expect(response.body).to include 'Condo Test'
    expect(response.body).to include 'TODAS AS TAXAS'
    expect(response.body).to include 'Fundo de Reserva'
    expect(response.body).to include 'Destinado a cobrir despesas imprevistas'
    expect(response.body).to include 'Recorrência'
    expect(response.body).to include 'Mensal'
    expect(response.body).to include 'Jardinagem'
    expect(response.body).to include 'Cuidar das arvores do condomínio'
    expect(response.body).to include 'Bimestral'
  end

  it 'falha pois não está associado' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')

    allow(Condo).to receive(:find).and_return(condo)

    login_as admin, scope: :admin
    get condo_base_fees_path(condo.id)

    expect(response).to have_http_status :found
    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq I18n.t('errors.messages.must_be_super_admin')
  end
end
