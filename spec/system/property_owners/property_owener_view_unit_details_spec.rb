require 'rails_helper'

describe 'Proprietário vee detalhes da sua unidade' do
  it 'quando ela está alugada' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    units = []
    units << Unit.new(id: 2, area: 120, floor: 3, number: 4, unit_type_id: 2, owner_name: 'Jules',
                      tenant_id: 2, owner_id: 1, description: 'Apartamento 2 quartos', condo_name: 'Condo Test')
    allow(Unit).to receive(:find_all_by_owner).and_return(units)
    allow(Unit).to receive(:find).and_return(units[0])

    login_as property_owner, scope: :property_owner
    visit root_path
    click_on 'Condo Test'

    within('div#unit-modal') do
      expect(page).to have_content 'Apartamento 2 quartos'
      expect(page).to have_content 'número da unidade'
      expect(page).to have_content '34'
      expect(page).to have_link 'Configurar Aluguel'
    end
  end
end