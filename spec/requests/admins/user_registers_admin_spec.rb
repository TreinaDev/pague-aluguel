require 'rails_helper'

describe 'usuario tenta criar conta de administrador' do
  it 'e sucede' do
    admin = FactoryBot.create(:admin, first_name: 'Fulano', last_name: 'Da Costa')
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

    expect(response).to redirect_to admins_path
    expect(flash[:notice]).to eq I18n.t('devise.registrations.signed_up')
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
    expect(flash[:notice]).to eq I18n.t('errors.messages.must_be_logged_in')
  end
end
