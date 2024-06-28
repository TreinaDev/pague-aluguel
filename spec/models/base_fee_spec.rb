require 'rails_helper'

RSpec.describe BaseFee, type: :model do
  describe 'valid?' do
    context 'presence' do
      it 'validates presence' do
        base_fee = BaseFee.create(name: '', description: '', late_payment: '',
                                  late_fee: '', charge_day: '')

        expect(base_fee).not_to be_valid
        expect(base_fee.errors).to include(:name)
        expect(base_fee.errors).to include(:description)
        expect(base_fee.errors).to include(:late_payment)
        expect(base_fee.errors).to include(:late_fee)
        expect(base_fee.errors).to include(:charge_day)
      end
    end
  end
end
