require 'rails_helper'

describe 'Proprietário vê dashboard' do
  it 'ao logar' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    units = []
    units << Unit.new(id: 1, area: 100, floor: 2, number: 3, unit_type_id: 1)
    units << Unit.new(id: 2, area: 120, floor: 3, number: 4, unit_type_id: 2)
    units << Unit.new(id: 3, area: 130, floor: 4, number: 5, unit_type_id: 3)
    allow(Unit).to receive(:find).and_return(units[0], units[1], units[2])
    allow(Unit).to receive(:find_all_by_owner).and_return(units)

    login_as property_owner, scope: :property_owner
    visit root_path

    within('div#property-owner-dashboard') do
      expect(page).to have_content 'Perfil'
      expect(page).to have_content 'propertyownertest@mail.com'
      expect(page).to have_content CPF.new(property_owner.document_number).formatted
      expect(page).to have_content 'Unidades'
      expect(page).to have_content 'Unidade 1'
      expect(page).to have_content 'Unidade 2'
      expect(page).to have_content 'Unidade 3'
    end
    expect(current_path).to eq root_path
  end
end
