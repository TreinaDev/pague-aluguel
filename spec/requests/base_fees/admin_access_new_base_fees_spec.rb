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
    expect(response.body).to include 'Nome'
    expect(response.body).to include 'Descrição'
    expect(response.body).to include 'Juros ao dia (%)'
    expect(response.body).to include 'Multa por atraso'
    expect(response.body).to include 'Data de Emissão'
    expect(response.body).to include 'Taxa limitada'
    expect(response.body).to include 'Número de Parcelas'
    expect(response.body).to include 'Recorrência'
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
    expect(response.body).to include 'Nome'
    expect(response.body).to include 'Descrição'
    expect(response.body).to include 'Juros ao dia (%)'
    expect(response.body).to include 'Multa por atraso'
    expect(response.body).to include 'Data de Emissão'
    expect(response.body).to include 'Taxa limitada'
    expect(response.body).to include 'Número de Parcelas'
    expect(response.body).to include 'Recorrência'
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
    expect(flash[:notice]).to eq 'Você não tem autorização para completar esta ação.'
  end
end
