require 'rails_helper'

RSpec.describe SingleCharge, type: :model do
  describe '#valid?' do
    it { should validate_presence_of(:unit_id) }
    it { should validate_presence_of(:issue_date) }
    it { should validate_numericality_of(:value).is_greater_than(0) }

    it 'common_area_is_mandatory' do
      single_charge = SingleCharge.new(charge_type: 'common_area_fee')

      single_charge.valid?

      expect(single_charge.errors.include?(:common_area_id)).to be true
      expect(single_charge.errors.full_messages).to include 'Área Comum deve ser selecionada.'
    end

    it 'date_is_future' do
      single_charge = SingleCharge.new(issue_date: 5.days.ago.to_date)

      single_charge.valid?

      expect(single_charge.errors.include?(:issue_date)).to be true
      expect(single_charge.errors.full_messages).to include 'Data de Emissão deve ser a partir de hoje.'
    end

    it 'description_is_mandatory' do
      single_charge = SingleCharge.new(charge_type: 'other')
      single_charge_two = SingleCharge.new(charge_type: 'fine')
      single_charge_three = SingleCharge.new(charge_type: 'common_area_fee')

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

    it ''
  end
end
