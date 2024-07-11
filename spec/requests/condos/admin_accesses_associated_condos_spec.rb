require 'rails_helper'

describe 'admin acessa condo específico' do
  it 'com sucesso - já que está associado ao condo' do
    admin = FactoryBot.create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:find).and_return(condo)
    common_areas = []
    common_areas << CommonArea.new(id: 1, name: 'Academia',
                                   description: 'Uma academia raíz com ventilador apenas para os marombas',
                                   max_occupancy: 20, rules: 'Não pode ser frango')
    allow(CommonArea).to receive(:all).and_return(common_areas)
    common_area = common_areas.first
    common_area_json = common_area.to_json
    fake_response = double('faraday_response', status: 200, body: common_area_json, success?: true)
    allow(Faraday).to receive(:get).with("http://127.0.0.1:3000/api/v1/condos/#{condo.id}/common_areas/#{common_area.id}").and_return(fake_response)
    AssociatedCondo.create!(admin:, condo_id: 1)

    login_as admin, scope: :admin
    get condo_path(condo.id)

    expect(response).to have_http_status(200)
    expect(response.body).to include 'Condo Test'
  end

  it 'e falha por não estar associado a este condo' do
    admin = FactoryBot.create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:find).and_return(condo)
    login_as admin, scope: :admin

    get condo_path(condo.id)

    expect(response).to have_http_status(302)
    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq I18n.t('errors.messages.must_be_super_admin')
  end
end
