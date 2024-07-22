require 'rails_helper'

RSpec.describe 'Proprietário tenta emitir certificado de debito negativo' do
  it 'com sucesso' do
    freeze_time do
      cpf = CPF.generate
      allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
      property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                               document_number: cpf)

      condos = []
      condos << Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'City Test')
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condos.first)

      units = []
      units << Unit.new(id: 2, area: 120, floor: 3, number: 22, unit_type_id: 2, owner_name: 'Jules',
                        tenant_id: 2, owner_id: 1, condo_id: 1, description: 'Apartamento 2 quartos',
                        condo_name: 'Condo Test', tower_name: 'Bloco 1')
      allow(Unit).to receive(:find_all_by_owner).and_return(units)
      allow(Unit).to receive(:find).and_return(units[0])
      create(:bill, unit_id: 1, condo_id: 1, status: :paid)

      login_as property_owner, scope: :property_owner
      visit unit_path(2)
      click_on 'Emitir Certificado'

      expect(page).to have_content 'Certidão de quitação emitida com sucesso'
      expect(page).to have_content I18n.l(Time.zone.now)
      expect(current_path).to eq certificate_condo_nd_certificate_path(condo_id: condos.first.id, id: 1)
      expect(page).to have_content 'Condomínio: Condomínio Vila das Flores'
      expect(page).to have_content 'Unidade: 22'
    end
  end

  it 'e falha pois possui débitos pendentes' do
    cpf = CPF.generate
    allow(Faraday).to receive(:get).and_return(instance_double('Faraday::Response', success?: true))
    property_owner = create(:property_owner, email: 'propertyownertest@mail.com', password: '123456',
                                             document_number: cpf)

    condos = []
    condos << Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'City Test')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condos.first)

    units = []
    units << Unit.new(id: 2, area: 120, floor: 3, number: 22, unit_type_id: 2, owner_name: 'Jules',
                      tenant_id: 1, owner_id: 1, condo_id: 1, description: 'Apartamento 2 quartos',
                      condo_name: 'Condo Test', tower_name: 'Bloco 1')
    allow(Unit).to receive(:find_all_by_owner).and_return(units)
    allow(Unit).to receive(:find).and_return(units[0])
    allow(Unit).to receive(:all).and_return(units[0])
    create(:bill, unit_id: 2, condo_id: 1, status: :pending)
    create(:bill, unit_id: 2, condo_id: 1, status: :paid)
    create(:bill, unit_id: 2, condo_id: 1, status: :awaiting)

    login_as property_owner, scope: :property_owner
    visit unit_path(2)
    click_on 'Emitir Certificado'

    expect(page).to have_content 'Esta unidade possui débitos pendentes.'
  end
end
