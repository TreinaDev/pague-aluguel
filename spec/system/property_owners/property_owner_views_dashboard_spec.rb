require 'rails_helper'

describe 'Proprietário vê dashboard' do
  it 'ao logar' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    condos << Condo.new(id: 2, name: 'Condo Test 2', city: 'City Test')
    condos << Condo.new(id: 3, name: 'Condo Test 3', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    units = []
    units << Unit.new(id: 1, area: 100, floor: 2, number: 3, unit_type_id: 1, condo_name: condos[0].name)
    units << Unit.new(id: 2, area: 120, floor: 3, number: 4, unit_type_id: 2, condo_name: condos[1].name)
    units << Unit.new(id: 3, area: 130, floor: 4, number: 5, unit_type_id: 3, condo_name: condos[2].name)
    allow(Unit).to receive(:find).and_return(units[0], units[1], units[2])
    allow(Unit).to receive(:find_all_by_owner).and_return(units)

    login_as property_owner, scope: :property_owner
    visit root_path
    within('div#units') do
      click_on 'Ver todas'
    end

    within('div#property-owner-dashboard') do
      expect(page).to have_content 'Meu perfil'
      expect(page).to have_content 'propertyownertest@mail.com'
      expect(page).to have_content CPF.new(property_owner.document_number).formatted
      expect(page).to have_content 'Minhas unidades'
      expect(page).to have_content 'Condo Test'
      expect(page).to have_content 'Condo Test 2'
      expect(page).to have_content 'Condo Test 3'
    end
    expect(current_path).to eq root_path
  end
end
