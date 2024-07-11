require 'rails_helper'

describe 'admin acessa condo específico' do
  it 'com sucesso - já que está associado ao condo' do
    admin = FactoryBot.create(:admin, super_admin: false)
    condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:find).and_return(condo)
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
