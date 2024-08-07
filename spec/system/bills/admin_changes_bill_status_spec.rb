require 'rails_helper'

describe 'Admin altera status da fatura' do
  context 'com sucesso' do
    it 'para paga aceitando o pagamento' do
      admin = create(:admin)
      condos = []
      condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
      condos << condo
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                                 unit_ids: [])
      units = []
      units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      units << Unit.new(id: 2, area: 40, floor: 1, number: '12', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condo)
      allow(CommonArea).to receive(:all).and_return([])
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).with(1).and_return(units.first)
      allow(Unit).to receive(:find).with(2).and_return(units.second)

      bills = []
      bills << create(:bill, condo_id: 1, unit_id: units[0].id, issue_date: Time.zone.today.beginning_of_month,
                             due_date: 10.days.from_now, total_value_cents: 500_00)
      bills << create(:bill, condo_id: 1, unit_id: units[1].id, issue_date: Time.zone.today.beginning_of_month,
                             due_date: 10.days.from_now, total_value_cents: 700_00, status: :awaiting)
      create(:receipt, bill_id: Bill.last.id)

      login_as admin, scope: :admin
      visit condo_bills_path(condo_id: condo.id)

      click_on 'Unidade 12'
      expect(page).to have_link 'Ver comprovante'
      accept_confirm 'Tem certeza que deseja aceitar o pagamento? Essa ação não poderá ser desfeita.' do
        click_on 'Aceitar pagamento'
      end

      expect(page).to have_content 'Pagamento efetivado!'
      expect(page).not_to have_content 'Aceitar pagamento'
      within('a#bill_1') do
        expect(page).to have_content 'pendente'.upcase
      end
      within('a#bill_2') do
        expect(page).to have_content 'paga'.upcase
      end
    end

    it 'para pendente rejeitando o pagamento e exclui recibo antigo' do
      admin = create(:admin)
      condos = []
      condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
      condos << condo
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                                 unit_ids: [])
      units = []
      units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      units << Unit.new(id: 2, area: 40, floor: 1, number: '12', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condo)
      allow(CommonArea).to receive(:all).and_return([])
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).with(1).and_return(units.first)
      allow(Unit).to receive(:find).with(2).and_return(units.second)

      bills = []
      bills << create(:bill, condo_id: 1, unit_id: units[0].id, issue_date: Time.zone.today.beginning_of_month,
                             due_date: 10.days.from_now, total_value_cents: 500_00, status: :paid)
      bills << create(:bill, condo_id: 1, unit_id: units[1].id, issue_date: Time.zone.today.beginning_of_month,
                             due_date: 10.days.from_now, total_value_cents: 700_00, status: :awaiting)
      create(:receipt, bill_id: Bill.first.id)
      create(:receipt, bill_id: Bill.last.id)

      login_as admin, scope: :admin
      visit condo_bills_path(condo_id: condo.id)

      click_on 'Unidade 12'
      expect(page).to have_link 'Ver comprovante'
      accept_confirm 'Tem certeza que deseja recusar o pagamento? Essa ação não poderá ser desfeita.' do
        click_on 'Recusar pagamento'
      end

      expect(page).to have_content 'Pagamento recusado!'
      expect(page).not_to have_content 'Recusar pagamento'
      within('a#bill_1') do
        expect(page).to have_content 'paga'.upcase
      end
      within('a#bill_2') do
        expect(page).to have_content 'pendente'.upcase
      end
      expect(Receipt.count).to eq 1
      expect(Bill.find_by(id: bills[1].id).denied?).to eq true
    end
  end
end
