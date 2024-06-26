require 'rails_helper'

RSpec.describe CommonArea, type: :model do
  describe '#Valid?' do
    it 'e não pode ser negativo' do
      condo = Condo.create!(name: 'Sai de baixo', city: 'Rio de Janeiro')

      common_area = CommonArea.create!(name: 'TMNT', description: 'Teenage Mutant Ninja Turtles', max_capacity: 40,
                                       usage_rules: 'Não lutar no salão', condo:)

      common_area.update(fee: -20)

      expect(common_area.errors[:fee]).to include(' não pode ser negativa.')
    end

    it 'e deve ser um inteiro' do
      common_area = CommonArea.new(fee: 0.2)

      common_area.valid?

      expect(common_area.errors[:fee]).to include('não é um número inteiro')
    end
  end
end
