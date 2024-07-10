require 'rails_helper'

RSpec.describe Bill, type: :model do
  context 'calculate fee' do
    it 'e retorna valor total da fatura' do
      condo = Condo.new(id: 1, name: 'Prédio lindo', city: 'Cidade maravilhosa')
      unit_types = []
      unit_types << UnitType.new(id: 1, area: 30, description: 'Apartamento 1 quarto', ideal_fraction: 0.1,
                                 condo_id: 1)
      units = []
      units << Unit.new(id: 1, area: 100, floor: 1, number: 1, unit_type_id: 1)
      shared_fee = create(:shared_fee, description: 'Descrição', issue_date: 10.days.from_now.to_date,
                                       total_value: 30_000_00, condo_id: condo.id)
      shared_fee_fraction = create(:shared_fee_fraction, shared_fee:, unit_id: 1, value_cents: 300_00)
      base_fee = create(:base_fee, condo_id: 1)
      value = create(:value, price_cents: 100_00, base_fee_id: base_fee.id)
      allow(Condo).to receive(:find).and_return(condo)
      allow(UnitType).to receive(:find_all_by_condo).and_return(unit_types)
      allow(Unit).to receive(:find).and_return(units.first)
      allow(Unit).to receive(:find_all_by_condo).and_return(units)

      bill = Bill.new(unit_id: units.first.id, issue_date: Date.today, due_date: Date.today)

      fees = bill.calculate_fees

      expect(fees).to eq 400_00
    end
  end
end
