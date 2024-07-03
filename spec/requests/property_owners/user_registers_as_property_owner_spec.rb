require 'rails_helper'

describe 'usuario tenta criar conta de proprietário', type: :request do
  it 'porém cpf não foi validado' do
    post property_owner_registration_path, params: {
      property_owners: {
        email: 'beltrano@mail.com',
        password: '123456',
        document_id: CPF.generate
      }
    }

    expect(flash[:notice]).to eq I18n.t('devise.failure.document_id_not_valideted')
  end
end
