require 'rails_helper'

describe 'usuario tenta criar conta de administrador' do
  it 'como super admin e sucede' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa', super_admin: true)
    login_as admin, scope: :admin
    post admins_path, params: {
      admin: {
        first_name: 'Beltrano',
        last_name: 'Da Silva',
        email: 'beltrano@mail.com',
        password: '123456',
        document_number: CPF.generate
      }
    }

    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq 'Cadastro realizado com sucesso.'
  end

  it 'e falha por não estar autenticado' do
    post admins_path, params: {
      admin: {
        first_name: 'Beltrano',
        last_name: 'Da Silva',
        email: 'beltrano@mail.com',
        password: '123456',
        document_number: CPF.generate
      }
    }

    expect(response).to redirect_to new_admin_session_path
    expect(flash[:notice]).to eq 'Você precisa estar autenticado para continuar.'
  end

  it 'e falha por não ser super admin' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa', super_admin: false)
    login_as admin, scope: :admin
    post admins_path, params: {
      admin: {
        first_name: 'Beltrano',
        last_name: 'Da Silva',
        email: 'beltrano@mail.com',
        password: '123456',
        document_number: CPF.generate
      }
    }

    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq 'Você não tem autorização para completar esta ação.'
  end

  it 'acessando a pagina de registro e falha' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa', super_admin: false)
    login_as admin, scope: :admin
    get new_admin_registration_path

    expect(response).to redirect_to root_path
    expect(flash[:notice]).to eq 'Você não tem autorização para completar esta ação.'
  end
end
