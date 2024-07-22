require 'rails_helper'

describe 'Proprietário edita propria conta' do
  it 'com sucesso' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

    condos = []
    condos << Condo.new(id: 1, name: 'Condo Test', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)

    units = []
    units << Unit.new(id: 1, area: 100, floor: 2, number: 3, unit_type_id: 1)
    allow(Unit).to receive(:find).and_return(units[0])
    allow(Unit).to receive(:find_all_by_owner).and_return(units)

    login_as property_owner, scope: :property_owner
    visit root_path
    find('#edit-profile').click

    fill_in 'Nome', with: 'Ciclano'
    fill_in 'Sobrenome', with: 'Da Silva'
    attach_file 'Foto', Rails.root.join('spec/support/images/reuri.jpeg')
    click_on 'Atualizar'

    expect(page).to have_content 'A sua conta foi atualizada com sucesso.'
    expect(page).to have_content 'Ciclano Da Silva'
    expect(page).to have_css "img[src*='reuri.jpeg']"
    expect(page).not_to have_content 'Fulano Da Costa'
  end
end
