require 'rails_helper'

describe 'Admin vê detalhes de uma fatura' do
  context 'a partir da tela de listagem de faturas' do
    it 'com status pendente' do
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
                             due_date: 10.days.from_now, total_value_cents: 700_00)

      login_as admin, scope: :admin
      visit condo_bills_path(condo_id: condo.id)
      click_on 'Unidade 12'

      formatted_issue_date = I18n.l(Time.zone.today.beginning_of_month)
      formatted_due_date = I18n.l(10.days.from_now.to_date)
      expect(page).to have_content 'Fatura'
      expect(page).to have_content 'Unidade 12'
      expect(page).to have_content 'Condomínio Vila das Flores'
      expect(page).to have_content 'data de emissão'
      expect(page).to have_content formatted_issue_date
      expect(page).to have_content 'data de vencimento'
      expect(page).to have_content formatted_due_date
      expect(page).to have_content 'valor total'
      expect(page).to have_content 'R$700,00'
      expect(page).to have_content 'taxa condominial'
      # lembrar de adicionar expect com valor especifico de cada taxa
      expect(page).to have_content 'conta compartilhada'
      expect(page).to have_content 'PENDENTE'
      expect(page).not_to have_button 'Ver comprovante'
      expect(page).not_to have_button 'Aceitar pagamento'
      expect(page).not_to have_button 'Recusar pagamento'
    end

    it 'com status aguardando' do
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

      formatted_issue_date = I18n.l(Time.zone.today.beginning_of_month)
      formatted_due_date = I18n.l(10.days.from_now.to_date)
      expect(page).to have_content 'Fatura'
      expect(page).to have_content 'Unidade 12'
      expect(page).to have_content 'Condomínio Vila das Flores'
      expect(page).to have_content 'data de emissão'
      expect(page).to have_content formatted_issue_date
      expect(page).to have_content 'data de vencimento'
      expect(page).to have_content formatted_due_date
      expect(page).to have_content 'valor total'
      expect(page).to have_content 'R$700,00'
      expect(page).to have_content 'taxa condominial'
      # lembrar de adicionar expect com valor especifico de cada taxa
      expect(page).to have_content 'conta compartilhada'
      expect(page).to have_content 'AGUARDANDO'
      expect(page).to have_link 'Ver comprovante'
      expect(page).to have_button 'Aceitar pagamento'
      expect(page).to have_button 'Recusar pagamento'
    end

    it 'com status paga' do
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
                             due_date: 10.days.from_now, total_value_cents: 700_00, status: :paid)
      create(:receipt, bill_id: Bill.last.id)

      login_as admin, scope: :admin
      visit condo_bills_path(condo_id: condo.id)
      click_on 'Unidade 12'

      formatted_issue_date = I18n.l(Time.zone.today.beginning_of_month)
      formatted_due_date = I18n.l(10.days.from_now.to_date)
      expect(page).to have_content 'Fatura'
      expect(page).to have_content 'Unidade 12'
      expect(page).to have_content 'Condomínio Vila das Flores'
      expect(page).to have_content 'data de emissão'
      expect(page).to have_content formatted_issue_date
      expect(page).to have_content 'data de vencimento'
      expect(page).to have_content formatted_due_date
      expect(page).to have_content 'valor total'
      expect(page).to have_content 'R$700,00'
      expect(page).to have_content 'taxa condominial'
      # lembrar de adicionar expect com valor especifico de cada taxa
      expect(page).to have_content 'conta compartilhada'
      expect(page).to have_content 'PAGA'
      expect(page).to have_link 'Ver comprovante'
      expect(page).not_to have_button 'Aceitar pagamento'
      expect(page).not_to have_button 'Recusar pagamento'
    end
  end
end
