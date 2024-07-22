# rubocop:disable Metrics/BlockLength
require 'rails_helper'

describe 'Inquilino tenta emitir certificado de débito negativo' do
  it 'com sucesso' do
    freeze_time do
      cpf = CPF.generate
      data = Rails.root.join('spec/support/json/tenant.json').read
      response = double('response', success?: true, body: data)
      endpoint_route = "http://127.0.0.1:3000/api/v1/get_tenant_residence?registration_number=#{CPF.new(cpf).formatted}"
      allow(Faraday).to receive(:get).with(endpoint_route).and_return(response)
      condos = []
      condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
      condos << condo
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                                 unit_ids: [])
      units = []
      units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      units << Unit.new(id: 2, area: 40, floor: 1, number: '12', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condo)
      allow(CommonArea).to receive(:all).and_return([])
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)
      create(:bill, unit_id: 1, condo_id: 1, status: :paid)
      create(:bill, unit_id: 1, condo_id: 1, status: :paid)

      visit root_path
      within 'form#get_tenant_bill' do
        cpf.each_char { |char| find(:css, "input[id$='get_tenant_bill']").send_keys(char) }
        click_on 'Buscar'
      end
      click_on 'Emitir Certificado'

      expect(page).to have_content 'Certidão de quitação emitida com sucesso'
      expect(page).to have_content I18n.l(Time.zone.now)
      expect(current_path).to eq certificate_condo_nd_certificate_path(condo_id: condo.id, id: 1)
      expect(page).to have_content 'Condomínio: Condomínio Vila das Flores'
      expect(page).to have_content 'Unidade: 11'
    end
  end

  it 'e falha pois possui débitos pendentes' do
    cpf = CPF.generate
    data = Rails.root.join('spec/support/json/tenant.json').read
    response = double('response', success?: true, body: data)
    endpoint_route = "http://127.0.0.1:3000/api/v1/get_tenant_residence?registration_number=#{CPF.new(cpf).formatted}"
    allow(Faraday).to receive(:get).with(endpoint_route).and_return(response)
    condos = []
    condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
    condos << condo
    unit_types = []
    unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                               unit_ids: [])
    units = []
    units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    units << Unit.new(id: 2, area: 40, floor: 1, number: '12', unit_type_id: 1, condo_id: 1,
                      condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1, description: 'Com varanda')
    allow(Condo).to receive(:all).and_return(condos)
    allow(Condo).to receive(:find).and_return(condo)
    allow(CommonArea).to receive(:all).and_return([])
    allow(UnitType).to receive(:all).and_return(unit_types)
    allow(Unit).to receive(:all).and_return(units)
    allow(Unit).to receive(:find).and_return(units.first)
    create(:bill, unit_id: 1, condo_id: 1, status: :paid)
    create(:bill, unit_id: 1, condo_id: 1, status: :paid)
    create(:bill, unit_id: 1, condo_id: 1, status: :awaiting)

    visit root_path
    within 'form#get_tenant_bill' do
      cpf.each_char { |char| find(:css, "input[id$='get_tenant_bill']").send_keys(char) }
      click_on 'Buscar'
    end
    click_on 'Emitir Certificado'

    expect(page).to have_content 'Esta unidade possui débitos pendentes.'
  end
end

# rubocop:enable Metrics/BlockLength
