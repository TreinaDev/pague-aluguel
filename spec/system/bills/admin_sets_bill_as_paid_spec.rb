require 'rails_helper'

describe 'Admin marca fatura como paga' do
  context 'com sucesso' do
    it 'a partir da tela de listagem de faturas' do
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
                             due_date: 10.days.from_now, total_value_cents: 500_00, status:)
      bills << create(:bill, condo_id: 1, unit_id: units[1].id, issue_date: Time.zone.today.beginning_of_month,
                             due_date: 10.days.from_now, total_value_cents: 700_00, status: :paid)

      login_as admin, scope: :admin
      visit condo_bills_path(condo_id: condo.id)

      click_on 'Unidade 12'
      click_on 'Marcar como paga'

      expect(page).to have_content 'Fatura paga com sucesso!'
      expect(page).not_to have_content 'Marcar como paga'
      within('a#bill_2') do
        expect(page).to have_content 'não paga'
      end
      within('a#bill_2') do
        expect(page).to have_content 'paga'
      end
    end
  end
end
