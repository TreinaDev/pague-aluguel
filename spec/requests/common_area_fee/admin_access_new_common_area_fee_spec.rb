require 'rails_helper'

describe 'Administrador acessa formulário de Taxa de área comum' do
  it 'sucesso - super admin' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: true)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    common_area = CommonArea.new(id: 1, name: 'Academia',
                                 description: 'Uma academia raíz com ventilador apenas para os marombas',
                                 max_occupancy: 20, rules: 'Não pode ser frango')
    allow(CommonArea).to receive(:find).and_return(common_area)

    login_as admin, scope: :admin
    get new_condo_common_area_common_area_fee_path(condo.id, common_area.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Áreas Comuns'
    expect(response.body).to include 'Academia'
    expect(response.body).to include 'Taxa'
  end

  it 'sucesso - admin coom acesso' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: false)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    common_area = CommonArea.new(id: 1, name: 'Academia',
                                 description: 'Uma academia raíz com ventilador apenas para os marombas',
                                 max_occupancy: 20, rules: 'Não pode ser frango')
    allow(CommonArea).to receive(:find).and_return(common_area)
    AssociatedCondo.create(admin:, condo_id: condo.id)

    login_as admin, scope: :admin
    get new_condo_common_area_common_area_fee_path(condo.id, common_area.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Áreas Comuns'
    expect(response.body).to include 'Academia'
    expect(response.body).to include 'Taxa'
  end

  it 'falha pois nao esta associad' do
    admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: false)
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    allow(Condo).to receive(:find).and_return(condo)

    common_area = CommonArea.new(id: 1, name: 'Academia',
                                 description: 'Uma academia raíz com ventilador apenas para os marombas',
                                 max_occupancy: 20, rules: 'Não pode ser frango')
    allow(CommonArea).to receive(:find).and_return(common_area)

    login_as admin, scope: :admin
    get new_condo_common_area_common_area_fee_path(condo.id, common_area.id)

    expect(response).to have_http_status :found
    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq 'Você não tem autorização para completar esta ação.'
    expect(response.body).not_to include 'Áreas Comuns'
    expect(response.body).not_to include 'Academia'
    expect(response.body).not_to include 'Taxa'
  end
end
