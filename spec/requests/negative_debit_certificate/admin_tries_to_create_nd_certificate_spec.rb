require 'rails_helper'

RSpec.describe 'NdCertificates', type: :request do
  describe 'GET /index' do
    it 'permite admins autorizados acessar a listagem de unidades' do
      admin = create(:admin)
      condos = []
      condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
      condos << condo
      unit_types = []
      unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                                 unit_ids: [])
      units = []
      units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1,
                        description: 'Com varanda')
      units << Unit.new(id: 2, area: 40, floor: 1, number: '12', unit_type_id: 1, condo_id: 1,
                        condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1,
                        description: 'Com varanda')
      allow(Condo).to receive(:all).and_return(condos)
      allow(Condo).to receive(:find).and_return(condo)
      allow(CommonArea).to receive(:all).and_return([])
      allow(UnitType).to receive(:all).and_return(unit_types)
      allow(Unit).to receive(:all).and_return(units)
      allow(Unit).to receive(:find).and_return(units.first)
      create(:bill, unit_id: 1, condo_id: 1, status: :paid)

      login_as admin, scope: :admin
      get condo_nd_certificates_path(condo_id: condo.id)

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /create' do
    context 'sem débitos pendentes' do
      it 'e emite com sucesso certificado' do
        admin = create(:admin)
        condos = []
        condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
        condos << condo
        unit_types = []
        unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                                   unit_ids: [])
        units = []
        units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                          condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1,
                          description: 'Com varanda')
        units << Unit.new(id: 2, area: 40, floor: 1, number: '12', unit_type_id: 1, condo_id: 1,
                          condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1,
                          description: 'Com varanda')
        allow(Condo).to receive(:all).and_return(condos)
        allow(Condo).to receive(:find).and_return(condo)
        allow(CommonArea).to receive(:all).and_return([])
        allow(UnitType).to receive(:all).and_return(unit_types)
        allow(Unit).to receive(:all).and_return(units)
        allow(Unit).to receive(:find).and_return(units.first)
        create(:bill, unit_id: 1, condo_id: 1, status: :paid)

        login_as admin, scope: :admin
        post condo_nd_certificates_path(condo_id: units.first.condo_id, unit_id: units.first.id)

        expect(response).to redirect_to(certificate_condo_nd_certificate_path(condo_id: units.first.condo_id, id: 1))
        expect(flash[:notice]).to eq(I18n.t('success_issued'))
      end
    end

    context 'quando unidade possui debitos pendentes' do
      it 'nao consegue emitir certificado algum' do
        admin = create(:admin)
        condos = []
        condo = Condo.new(id: 1, name: 'Condomínio Vila das Flores', city: 'São Paulo')
        condos << condo
        unit_types = []
        unit_types << UnitType.new(id: 1, description: 'Apartamento 1 quarto', metreage: 40, fraction: 0.5,
                                   unit_ids: [])
        units = []
        units << Unit.new(id: 1, area: 40, floor: 1, number: '11', unit_type_id: 1, condo_id: 1,
                          condo_name: 'Condomínio Vila das Flores', tenant_id: 1, owner_id: 1,
                          description: 'Com varanda')
        units << Unit.new(id: 2, area: 40, floor: 1, number: '12', unit_type_id: 1, condo_id: 1,
                          condo_name: 'Condomínio Vila das Flores', tenant_id: 1,
                          owner_id: 1, description: 'Com varanda')
        allow(Condo).to receive(:all).and_return(condos)
        allow(Condo).to receive(:find).and_return(condo)
        allow(CommonArea).to receive(:all).and_return([])
        allow(UnitType).to receive(:all).and_return(unit_types)
        allow(Unit).to receive(:all).and_return(units)
        allow(Unit).to receive(:find).and_return(units.first)
        create(:bill, unit_id: 1, condo_id: 1, status: :pending)

        login_as admin, scope: :admin
        post condo_nd_certificates_path(condo_id: units.first.condo_id, unit_id: units.first.id)

        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq(I18n.t('pending_debt'))
      end
    end
  end
end
