require 'rails_helper'

describe 'Admin acessa detalhes de uma area comum' do
  it 'sucesso - pois esta associado ao condo' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    common_area = CommonArea.new(id: 1, name: 'Academia',
                                 description: 'Uma academia raíz com ventilador apenas para os marombas',
                                 max_occupancy: 20, rules: 'Não pode ser frango')
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:find).and_return(common_area)
    AssociatedCondo.create!(admin:, condo_id: 1)

    login_as admin, scope: :admin
    get condo_common_area_path(condo.id, common_area.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Academia'
    expect(response.body).to include 'Uma academia raíz com ventilador apenas para os marombas'
  end

  it 'sucesso - super admin' do
    admin = create(:admin, super_admin: true)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    common_area = CommonArea.new(id: 1, name: 'Academia',
                                 description: 'Uma academia raíz com ventilador apenas para os marombas',
                                 max_occupancy: 20, rules: 'Não pode ser frango')
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:find).and_return(common_area)

    login_as admin, scope: :admin
    get condo_common_area_path(condo.id, common_area.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Academia'
    expect(response.body).to include 'Uma academia raíz com ventilador apenas para os marombas'
  end

  it 'falha por nao estar associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    common_area = CommonArea.new(id: 1, name: 'Academia',
                                 description: 'Uma academia raíz com ventilador apenas para os marombas',
                                 max_occupancy: 20, rules: 'Não pode ser frango')
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:find).and_return(common_area)
    AssociatedCondo.create!(admin:, condo_id: 2)

    login_as admin, scope: :admin
    get condo_common_areas_path(condo.id, common_area.id)

    expect(response).to have_http_status :found
    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq 'Você não tem autorização para completar esta ação.'
  end
end
