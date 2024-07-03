require 'rails_helper'

describe 'Admin gerencia contas compartilhadas' do
  context 'criando' do
    it 'com sucesso' do
      admin = Admin.create!(
        email: 'admin@mail.com',
        password: '123456',
        first_name: 'Fulano',
        last_name: 'Da Costa',
        document_number: CPF.generate
      )
      condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
      unit_type_one = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.04)
      unit_type_two = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.06)
      FactoryBot.create_list(:unit, 10, unit_type: unit_type_one)
      FactoryBot.create_list(:unit, 10, unit_type: unit_type_two)

      login_as admin, scope: :admin
      post(shared_fees_path, params: { shared_fee: { description: 'Descrição',
                                                     issue_date: 10.days.from_now.to_date,
                                                     total_value: 1000,
                                                     condo_id: condominium.id } })

      expect(SharedFee.count).to eq 1
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(shared_fee_path(SharedFee.last.id.to_s))
      expect(SharedFee.last.description).to eq 'Descrição'
      expect(SharedFee.last.issue_date).to eq 10.days.from_now.to_date
      expect(SharedFee.last.total_value_cents).to eq 100_000
    end

    it 'e não está autenticado' do
      Admin.create!(
        email: 'admin@mail.com',
        password: '123456',
        first_name: 'Fulano',
        last_name: 'Da Costa',
        document_number: CPF.generate
      )
      condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
      unit_type_one = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.04)
      unit_type_two = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.06)
      FactoryBot.create_list(:unit, 10, unit_type: unit_type_one)
      FactoryBot.create_list(:unit, 10, unit_type: unit_type_two)

      post(shared_fees_path, params: { shared_fee: { description: 'Descrição',
                                                     issue_date: 10.days.from_now.to_date,
                                                     total_value_cents: 1000,
                                                     condo_id: condominium.id } })

      expect(SharedFee.count).to eq 0
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(new_admin_session_path)
    end
  end

  context 'deletando ' do
    it 'com sucesso' do
      admin = Admin.create!(
        email: 'admin@mail.com',
        password: '123456',
        first_name: 'Fulano',
        last_name: 'Da Costa',
        document_number: CPF.generate
      )

      condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
      unit_type_one = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.04)
      unit_type_two = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.06)
      FactoryBot.create_list(:unit, 10, unit_type: unit_type_one)
      FactoryBot.create_list(:unit, 10, unit_type: unit_type_two)
      sf = SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                             total_value: 10_000, condo: condominium)

      login_as admin, scope: :admin
      delete(shared_fee_path(sf.id))

      expect(SharedFee.count).to eq 0
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(shared_fees_path(condo_id: condominium.id))
    end

    it 'e não está autenticado' do
      Admin.create!(
        email: 'admin@mail.com',
        password: '123456',
        first_name: 'Fulano',
        last_name: 'Da Costa',
        document_number: CPF.generate
      )
      condominium = Condo.create!(name: 'Condo Test', city: 'City Test')
      unit_type_one = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.04)
      unit_type_two = FactoryBot.create(:unit_type, condo: condominium, ideal_fraction: 0.06)
      FactoryBot.create_list(:unit, 10, unit_type: unit_type_one)
      FactoryBot.create_list(:unit, 10, unit_type: unit_type_two)
      sf = SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                             total_value: 10_000, condo: condominium)

      delete(shared_fee_path(sf.id))

      expect(SharedFee.count).to eq 1
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(new_admin_session_path)
    end
  end
end
