require 'rails_helper'

describe 'Admin cancela uma taxa condominial' do
  it 'com sucesso - super admin' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: true)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    base_fee = create(:base_fee, condo_id: condo.id)

    login_as admin, scope: :admin
    post cancel_condo_base_fee_path(condo.id, base_fee.id)

    expect(response).to have_http_status :found
    expect(flash[:notice]).to eq "#{base_fee.name} cancelada com sucesso."
  end

  it 'com sucesso - Admin associado ao condominio' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    base_fee = create(:base_fee, condo_id: condo.id)
    AssociatedCondo.create(admin_id: admin.id, condo_id: condo.id)

    login_as admin, scope: :admin
    post cancel_condo_base_fee_path(condo.id, base_fee.id)

    expect(response).to have_http_status :found
    expect(flash[:notice]).to eq "#{base_fee.name} cancelada com sucesso."
  end

  it 'falha pois não está associado' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    base_fee = create(:base_fee, condo_id: condo.id)

    login_as admin, scope: :admin
    post cancel_condo_base_fee_path(condo.id, base_fee.id)

    expect(response).to have_http_status :found
    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq I18n.t('errors.messages.must_be_super_admin')
  end
end
