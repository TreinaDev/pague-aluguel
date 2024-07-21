require 'rails_helper'

RSpec.describe 'Comprovantes', type: :request do
  describe 'POST' do
    it 'cria um comprovante com um arquivo pdf anexado' do
      file = fixture_file_upload(Rails.root.join('spec/support/pdf/Comprovante-teste.pdf'), 'application/pdf')

      create(:bill, id: 1)
      post '/api/v1/receipts', params: { receipt: file, bill_id: '1' }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Comprovante recebido com sucesso!')
      expect(Receipt.count).to eq(1)
      expect(Receipt.first.file).to be_attached
    end

    it 'cria um comprovante com um arquivo jpg anexado' do
      file = fixture_file_upload(Rails.root.join('spec/support/images/reuri.jpeg'), 'image/jpeg')

      create(:bill, id: 1)
      post '/api/v1/receipts', params: { receipt: file, bill_id: '1' }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Comprovante recebido com sucesso!')
      expect(Receipt.count).to eq(1)
      expect(Receipt.first.file).to be_attached
    end

    it 'cria um comprovante com um arquivo png anexado' do
      file = fixture_file_upload(Rails.root.join('spec/support/images/foto-do-angelo.png'), 'image/png')

      create(:bill, id: 1)
      post '/api/v1/receipts', params: { receipt: file, bill_id: '1' }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Comprovante recebido com sucesso!')
      expect(Receipt.count).to eq(1)
      expect(Receipt.first.file).to be_attached
    end

    it 'retorna erro quando nenhum arquivo é enviado' do
      create(:bill, id: 1)
      post '/api/v1/receipts', params: { receipt: nil, bill_id: '1' }

      expect(response).to have_http_status(:bad_request)
      expect(response.body).to include('Nenhum arquivo enviado.')
      expect(Receipt.count).to eq(0)
    end

    it 'retorna erro quando arquivo enviado não é um pdf, jpg ou png' do
      file = fixture_file_upload(Rails.root.join('spec/support/images/best_game_ever.webp'), 'image/webp')

      create(:bill, id: 1)
      post '/api/v1/receipts', params: { receipt: file, bill_id: '1' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('O arquivo deve ser JPG, PNG ou PDF.')
      expect(Receipt.count).to eq(0)
    end

    it 'retorna erro quando o ID da fatura é inválido ou não é passado' do
      file = fixture_file_upload(Rails.root.join('spec/support/pdf/Comprovante-teste.pdf'), 'application/pdf')

      post '/api/v1/receipts', params: { receipt: file, bill_id: nil }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('ID da fatura não informado.')
      expect(Receipt.count).to eq(0)
    end
  end
end
