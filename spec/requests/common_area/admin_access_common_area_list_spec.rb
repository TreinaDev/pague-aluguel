require 'rails_helper'

describe 'Admin acessa a listagem de areas comuns' do
  it 'sucesso - pois esta associado ao condo' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Academia',
                                   description: 'Uma academia raíz com ventilador apenas para os marombas',
                                   max_occupancy: 20, rules: 'Não pode ser frango')
    common_areas << CommonArea.new(id: 2, name: 'Churrasqueira',
                                   description: 'Churrasqueira para os churrasqueiros de plantão',
                                   max_occupancy: 20, rules: 'Não pode comer frango')
    common_areas << CommonArea.new(id: 3, name: 'Sala de cinema',
                                   description: 'Cinema para os cinéfilos de plantão',
                                   max_occupancy: 20, rules: 'Não pode ver filme de frango')
    common_areas << CommonArea.new(id: 4, name: 'Cozinha compartilhada',
                                   description: 'Cozinha para os chefs de plantão',
                                   max_occupancy: 20, rules: 'Não pode cozinhar frango')
    common_areas << CommonArea.new(id: 5, name: 'Ping Pong',
                                   description: 'Mesa de ping pong para os ping pongueiros de plantão',
                                   max_occupancy: 20, rules: 'Não pode jogar ping pong de frango')
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:all).and_return(common_areas)
    AssociatedCondo.create!(admin:, condo_id: 1)

    login_as admin, scope: :admin
    get condo_common_areas_path(condo.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Ping Pong'
    expect(response.body).to include 'Mesa de ping pong para os ping pongueiros de plantão'
  end

  it 'sucesso - super admin' do
    admin = create(:admin, super_admin: true)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Academia',
                                   description: 'Uma academia raíz com ventilador apenas para os marombas',
                                   max_occupancy: 20, rules: 'Não pode ser frango')
    common_areas << CommonArea.new(id: 2, name: 'Churrasqueira',
                                   description: 'Churrasqueira para os churrasqueiros de plantão',
                                   max_occupancy: 20, rules: 'Não pode comer frango')
    common_areas << CommonArea.new(id: 3, name: 'Sala de cinema',
                                   description: 'Cinema para os cinéfilos de plantão',
                                   max_occupancy: 20, rules: 'Não pode ver filme de frango')
    common_areas << CommonArea.new(id: 4, name: 'Cozinha compartilhada',
                                   description: 'Cozinha para os chefs de plantão',
                                   max_occupancy: 20, rules: 'Não pode cozinhar frango')
    common_areas << CommonArea.new(id: 5, name: 'Ping Pong',
                                   description: 'Mesa de ping pong para os ping pongueiros de plantão',
                                   max_occupancy: 20, rules: 'Não pode jogar ping pong de frango')
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:all).and_return(common_areas)

    login_as admin, scope: :admin
    get condo_common_areas_path(condo.id)

    expect(response).to have_http_status :ok
    expect(response.body).to include 'Ping Pong'
    expect(response.body).to include 'Mesa de ping pong para os ping pongueiros de plantão'
  end

  it 'falha por nao estar associado' do
    admin = create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    common_areas = []
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:all).and_return(common_areas)
    AssociatedCondo.create!(admin:, condo_id: 2)

    login_as admin, scope: :admin
    get condo_common_areas_path(condo.id)

    expect(response).to have_http_status :found
    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq 'Você não tem autorização para completar esta ação.'
  end
end
