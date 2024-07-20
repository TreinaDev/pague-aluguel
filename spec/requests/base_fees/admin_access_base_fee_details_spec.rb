require 'rails_helper'

describe 'Admin acessa detalhes de uma taxa condominial' do
  it 'com sucesso - super admin' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: true)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_type = UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                             unit_ids: [])
    base_fee = create(:base_fee, condo_id: condo.id)

    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return([unit_type])

    login_as admin, scope: :admin
    get condo_base_fee_path(condo.id, base_fee.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Taxa de Condomínio'
    expect(response.body).to include 'Manutenção geral do condomínio.'
  end

  it 'com sucesso - Admin associado ao condominio' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_type = UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                             unit_ids: [])
    base_fee = create(:base_fee, condo_id: condo.id)
    AssociatedCondo.create(admin_id: admin.id, condo_id: condo.id)

    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return([unit_type])

    login_as admin, scope: :admin
    get condo_base_fee_path(condo.id, base_fee.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Taxa de Condomínio'
    expect(response.body).to include 'Manutenção geral do condomínio.'
  end

  it 'falha pois não está associado' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    unit_type = UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                             unit_ids: [])
    base_fee = create(:base_fee, condo_id: condo.id)

    allow(Condo).to receive(:find).and_return(condo)
    allow(UnitType).to receive(:all).and_return([unit_type])

    login_as admin, scope: :admin
    get condo_base_fee_path(condo.id, base_fee.id)

    expect(response).to have_http_status :found
    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq I18n.t('errors.messages.must_be_super_admin')
  end
end
