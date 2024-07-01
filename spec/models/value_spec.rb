require 'rails_helper'

RSpec.describe Value, type: :model do
  describe 'válido?' do
    context 'valor' do
      it 'valor deve ser diferente de 0' do
        value = build(:value, price: 0)

        expect(value).not_to be_valid
        expect(value.errors).to include(:price)
        expect(value.errors[:price]).to include('deve ser maior que 0')
      end

      it 'valor deve ser maior que 0' do
        value = build(:value, price: -50)

        expect(value).not_to be_valid
        expect(value.errors).to include(:price)
        expect(value.errors[:price]).to include('deve ser maior que 0')
      end
    end
  end
end
