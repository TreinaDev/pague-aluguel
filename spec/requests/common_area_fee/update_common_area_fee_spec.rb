require 'rails_helper'

describe 'Update Taxas de area comum' do
  it 'se não estiver autenticado' do
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    common_area = CommonArea.new(id: 1, name: 'Academia',
                                 description: 'Uma academia raíz com ventilador apenas para os marombas',
                                 max_occupancy: 20, rules: 'Não pode ser frango')
    allow(CommonArea).to receive(:find).and_return(common_area)

    url = condo_common_area_common_area_fees_path(condo.id, common_area.id)
    post url, params: { common_area_fee: { value: 300, common_area_id: common_area.id, condo_id: condo.id } }

    expect(response).to have_http_status :found
    expect(response).to redirect_to new_admin_session_path
    expect(CommonAreaFee.count).to be_zero
  end

  it 'sucesso - super admin' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: true)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    common_area = CommonArea.new(id: 1, name: 'Academia',
                                 description: 'Uma academia raíz com ventilador apenas para os marombas',
                                 max_occupancy: 20, rules: 'Não pode ser frango')
    allow(CommonArea).to receive(:find).and_return(common_area)

    login_as admin, scope: :admin
    url = condo_common_area_common_area_fees_path(condo.id, common_area.id)
    post url, params: { common_area_fee: { value: 300, common_area_id: common_area.id, condo_id: condo.id } }

    expect(response).to have_http_status :found
    expect(response).to redirect_to condo_common_area_path(condo.id, common_area.id)
    expect(flash[:notice]).to eq I18n.t('messages.registered_fee')
    expect(CommonAreaFee.first.value_cents).to eq 300_00
    expect(CommonAreaFee.first.common_area_id).to eq common_area.id
  end

  it 'sucesso - admin associado ao condominio' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: false)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)
    AssociatedCondo.create(admin:, condo_id: condo.id)
    common_area = CommonArea.new(id: 1, name: 'Academia',
                                 description: 'Uma academia raíz com ventilador apenas para os marombas',
                                 max_occupancy: 20, rules: 'Não pode ser frango')
    allow(CommonArea).to receive(:find).and_return(common_area)

    login_as admin, scope: :admin
    url = condo_common_area_common_area_fees_path(condo.id, common_area.id)
    post url, params: { common_area_fee: { value: 300, common_area_id: common_area.id, condo_id: condo.id } }

    expect(response).to have_http_status :found
    expect(response).to redirect_to condo_common_area_path(condo.id, common_area.id)
    expect(flash[:notice]).to eq I18n.t('messages.registered_fee')
    expect(CommonAreaFee.first.value_cents).to eq 300_00
    expect(CommonAreaFee.first.common_area_id).to eq common_area.id
  end

  it 'falha pois nao esta associado' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: false)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)
    common_area = CommonArea.new(id: 1, name: 'Academia',
                                 description: 'Uma academia raíz com ventilador apenas para os marombas',
                                 max_occupancy: 20, rules: 'Não pode ser frango')
    allow(CommonArea).to receive(:find).and_return(common_area)

    login_as admin, scope: :admin
    url = condo_common_area_common_area_fees_path(condo.id, common_area.id)
    post url, params: { common_area_fee: { value: 300, common_area_id: common_area.id, condo_id: condo.id } }

    expect(response).to have_http_status :found
    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq I18n.t('errors.messages.must_be_super_admin')
  end
end
