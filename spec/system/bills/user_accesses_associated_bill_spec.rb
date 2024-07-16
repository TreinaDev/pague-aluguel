require 'rails_helper'

describe 'Usuário acessa detalhes da fatura' do
  context 'como morador' do
    it 'a partir da homepage' do
      cpf = CPF.generate
      allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))

      condos = []
      condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
      allow(Condo).to receive(:all).and_return(condos)

      units = []
      units << Unit.new(id: 1, area: 100, floor: 2, number: 3, unit_type_id: 1)

      allow(Unit).to receive(:find).and_return(units.first)
    end
  end
end
