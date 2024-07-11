require 'rails_helper'

RSpec.describe SingleCharge, type: :model do
  describe '#valid?' do
    it { should validate_presence_of(:unit_id) }
    it { should validate_presence_of(:issue_date) }
    it { should validate_numericality_of(:value).is_greater_than(0) }

    it 'common_area_is_mandatory' do
      single_charge = build(:single_charge, charge_type: 'common_area_fee', common_area_id: '')

      single_charge.valid?

      expect(single_charge.errors.include?(:common_area_id)).to be true
      expect(single_charge.errors.full_messages).to include 'Área Comum deve ser selecionada.'
    end

    it 'date_is_future' do
      single_charge = build(:single_charge, issue_date: 5.days.ago.to_date)

      single_charge.valid?

      expect(single_charge.errors.include?(:issue_date)).to be true
      expect(single_charge.errors.full_messages).to include 'Data de Emissão deve ser a partir de hoje.'
    end

    it 'description_is_mandatory' do
      single_charge = build(:single_charge, charge_type: 'other', description: '')
      single_charge_two = build(:single_charge, charge_type: 'fine', description: '')
      single_charge_three = build(:single_charge, charge_type: 'common_area_fee', description: '')

      single_charge.valid?
      single_charge_two.valid?
      single_charge_three.valid?

      expect(single_charge.errors.include?(:description)).to be true
      expect(single_charge.errors.full_messages).to include 'Descrição não pode ficar em branco.'
      expect(single_charge_two.errors.include?(:description)).to be true
      expect(single_charge_two.errors.full_messages).to include 'Descrição não pode ficar em branco.'
      expect(single_charge_three.errors.include?(:description)).to be false
      expect(single_charge_three.errors.full_messages).not_to include 'Descrição não pode ficar em branco.'
    end

    it 'common_area_restriction' do
      create(:single_charge, charge_type: 'fine', common_area_id: 1)

      expect(SingleCharge.first).to be_valid
      expect(SingleCharge.first.charge_type).to eq 'fine'
      expect(SingleCharge.first.common_area_id).to be_nil
    end
  end
end
