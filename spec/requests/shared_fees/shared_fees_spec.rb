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
      condos = []
      condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quarto', metreage: 200, fraction: 2.0,
                                 unit_ids: [2])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      units << Unit.new(id: 2, area: 100, floor: 1, number: '12', unit_type_id: 2, condo_id: 1,
                        condo_name: 'Prédio lindo', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      allow(Unit).to receive(:all).and_return(units)
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:all).and_return(unit_types)

      login_as admin, scope: :admin
      post(condo_shared_fees_path(condos.first.id), params: { shared_fee: { description: 'Descrição',
                                                                            issue_date: 10.days.from_now.to_date,
                                                                            total_value: 1000 } })

      expect(SharedFee.count).to eq 1
      expect(SharedFee.last.shared_fee_fractions.length).to eq 2
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(condo_path(condos.first.id))
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
      condos = []
      condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quarto', metreage: 200, fraction: 2.0,
                                 unit_ids: [2])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      units << Unit.new(id: 2, area: 100, floor: 1, number: 1, unit_type_id: 2)
      allow(Unit).to receive(:all).and_return(units)
      allow(Condo).to receive(:all).and_return(condos)
      allow(UnitType).to receive(:all).and_return(unit_types)

      post(condo_shared_fees_path(condos.first.id), params: {
             shared_fee: {
               description: 'Descrição',
               issue_date: 10.days.from_now.to_date,
               total_value_cents: 1000
             }
           })

      expect(SharedFee.count).to eq 0
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(new_admin_session_path)
    end
  end

  context 'cancelando ' do
    it 'com sucesso' do
      admin = Admin.create!(
        email: 'admin@mail.com',
        password: '123456',
        first_name: 'Fulano',
        last_name: 'Da Costa',
        document_number: CPF.generate
      )
      condos = []
      condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quarto', metreage: 200, fraction: 2.0,
                                 unit_ids: [2])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      units << Unit.new(id: 2, area: 100, floor: 1, number: 1, unit_type_id: 2)

      allow(Unit).to receive(:all).and_return(units)
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first)
      allow(UnitType).to receive(:all).and_return(unit_types)

      sf = SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                             total_value: 10_000, condo_id: condos.first.id)

      shared_fee_fractions = SharedFee.last.shared_fee_fractions
      shared_fee_fractions_are_canceled = shared_fee_fractions.all?(&:canceled?)

      login_as admin, scope: :admin
      post(cancel_condo_shared_fee_path(condos.first.id, sf.id))

      expect(SharedFee.last.canceled?).to eq true
      expect(shared_fee_fractions_are_canceled).to eq true
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(condo_shared_fees_path(condos.first.id))
    end

    it 'e não está autenticado' do
      condos = []
      condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 100, fraction: 1.0,
                                 unit_ids: [1])
      unit_types << UnitType.new(id: 2, description: 'Apartamento 2 quarto', metreage: 200, fraction: 2.0,
                                 unit_ids: [2])
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      units << Unit.new(id: 2, area: 100, floor: 1, number: 1, unit_type_id: 2)
      allow(Unit).to receive(:all).and_return(units)
      allow(Condo).to receive(:all).and_return(condos)
      allow(UnitType).to receive(:all).and_return(unit_types)

      sf = SharedFee.create!(description: 'Conta de Luz', issue_date: 10.days.from_now.to_date,
                             total_value: 10_000, condo_id: condos.first.id)

      post(cancel_condo_shared_fee_path(condos.first.id, sf.id))

      expect(SharedFee.last.canceled?).to eq false
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(new_admin_session_path)
    end
  end
end
