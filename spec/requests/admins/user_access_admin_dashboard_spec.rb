require 'rails_helper'

describe 'usuario tenta acessar dashboard de administradores' do
  it 'com sucesso' do
    admin = FactoryBot.create(:admin)
    login_as admin, scope: :admin

    get admins_path

    expect(response).to have_http_status(200)
  end

  it 'e falha por não estar autenticado' do
    get admins_path

    expect(response).to have_http_status(302)
    expect(response).to redirect_to new_admin_session_path
  end
end
