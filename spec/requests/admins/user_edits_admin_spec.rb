require 'rails_helper'

describe 'usuario tenta editar conta de administrador' do
  context 'e sucede' do
    it 'como super admin' do
      admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
      login_as admin, scope: :admin
      patch admin_registration_path, params: {
        admin: {
          first_name: 'Beltrano',
          last_name: 'Da Silva',
          email: 'beltrano@mail.com',
          password: '123456',
          document_number: CPF.generate
        }
      }

      expect(response).to redirect_to root_path(admin.id)
      expect(flash[:notice]).to eq 'A sua conta foi atualizada com sucesso.'
    end
    it 'como admin' do
      admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa', super_admin: false)
      login_as admin, scope: :admin
      patch admin_registration_path, params: {
        admin: {
          first_name: 'Beltrano',
          last_name: 'Da Silva',
          email: 'beltrano@mail.com',
          password: '123456',
          document_number: CPF.generate
        }
      }

      expect(response).to redirect_to root_path(admin.id)
      expect(flash[:notice]).to eq 'A sua conta foi atualizada com sucesso.'
    end
  end
  it 'e falha por não estar autenticado' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
    patch admin_registration_path(admin), params: {
      admin: {
        first_name: 'Beltrano',
        last_name: 'Da Silva',
        email: 'beltrano@mail.com',
        password: '123456',
        document_number: CPF.generate
      }
    }

    expect(response.status).to eq 401
    expect(response.body).to eq 'Para continuar, faça login ou registre-se.'
  end
end
