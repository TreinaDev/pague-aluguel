require 'rails_helper'

describe 'Admin gerencia associações de condomínios' do
  context 'GET admins/:id/condos_selection' do
    it 'sucesso' do
      admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: true)
      condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      allow(Condo).to receive(:all).and_return([condo])

      login_as admin, scope: :admin
      get condos_selection_admin_path(admin)

      expect(response.body).to include('Condo Test')
    end

    it 'e falha por nao ter autorizacao' do
      admin = create(:admin, email: 'admin@email.com', password: '123456', super_admin: false)
      condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      allow(Condo).to receive(:all).and_return([condo])

      login_as admin, scope: :admin
      get condos_selection_admin_path(admin)

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não tem autorização para completar esta ação.'
    end
  end

  context 'POST admins/:id/condos_selection_post' do
    it 'sucesso' do
      admin1 = create(:admin, email: 'admin@email.com', password: '123456', super_admin: true)
      admin2 = create(:admin, email: 'bcdef@email.com', password: '654321', super_admin: false)

      login_as admin1, scope: :admin
      post condos_selection_post_admin_path(admin2), params: { condo_ids: [1, 2, 3] }

      expect(response).to redirect_to root_path
      expect(flash[:notice]).to eq 'Acesso aos condomínios atualizado com sucesso!'
      expect(admin2.associated_condos.first.condo_id).to eq 1
      expect(admin2.associated_condos.second.condo_id).to eq 2
      expect(admin2.associated_condos.last.condo_id).to eq 3
    end

    it 'e falha por nao ter autorizacao' do
      admin2 = create(:admin, email: 'bcdef@email.com', password: '654321', super_admin: false)

      login_as admin2, scope: :admin
      post condos_selection_post_admin_path(admin2), params: { condo_ids: [1, 2, 3] }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não tem autorização para completar esta ação.'
      expect(admin2.associated_condos.count).to eq 0
    end
  end
end
