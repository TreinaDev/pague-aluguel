require 'rails_helper'

describe 'Admin cancela uma conta compartilhada' do
  context 'cancelando' do
    it 'com sucesso - super admin' do
      admin = create(:admin, super_admin: true)
      condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      allow(Condo).to receive(:find).and_return(condo)

      sf = SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                             total_value: 10_000, condo_id: condo.id)

      shared_fee_fractions = SharedFee.last.shared_fee_fractions
      shared_fee_fractions_are_canceled = shared_fee_fractions.all?(&:canceled?)

      login_as admin, scope: :admin
      post(cancel_condo_shared_fee_path(condo.id, sf.id))

      expect(SharedFee.last.canceled?).to eq true
      expect(shared_fee_fractions_are_canceled).to eq true
      expect(response).to have_http_status :found
      expect(response).to redirect_to(condo_shared_fees_path(condo.id))
    end

    it 'com sucesso - admin esta associado' do
      admin = create(:admin, super_admin: false)
      condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      allow(Condo).to receive(:find).and_return(condo)
      AssociatedCondo.create!(admin_id: admin.id, condo_id: condo.id)

      sf = SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                             total_value: 10_000, condo_id: condo.id)

      shared_fee_fractions = SharedFee.last.shared_fee_fractions
      shared_fee_fractions_are_canceled = shared_fee_fractions.all?(&:canceled?)

      login_as admin, scope: :admin
      post(cancel_condo_shared_fee_path(condo.id, sf.id))

      expect(SharedFee.last.canceled?).to eq true
      expect(shared_fee_fractions_are_canceled).to eq true
      expect(response).to have_http_status :found
      expect(response).to redirect_to(condo_shared_fees_path(condo.id))
    end

    it 'falha por nao estar associado' do
      admin = create(:admin, super_admin: false)
      condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      allow(Condo).to receive(:find).and_return(condo)

      sf = SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                             total_value: 10_000, condo_id: condo.id)

      login_as admin, scope: :admin
      post(cancel_condo_shared_fee_path(condo.id, sf.id))

      expect(response).to have_http_status :found
      expect(response).to redirect_to root_path
      expect(flash[:notice]).to eq 'Você não tem autorização para completar esta ação.'
    end

    it 'e não está autenticado' do
      condo = Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      sf = SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                             total_value: 10_000, condo_id: condo.id)

      post(cancel_condo_shared_fee_path(condo.id, sf.id))

      expect(SharedFee.last.canceled?).to eq false
      expect(response).to have_http_status :found
      expect(response).to redirect_to(new_admin_session_path)
    end
  end
end
