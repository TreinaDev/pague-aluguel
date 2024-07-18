require 'rails_helper'

RSpec.describe 'Comprovantes', type: :request do
  describe 'POST' do
    it 'cria um comprovante com um arquivo pdf anexado' do
      file = fixture_file_upload(Rails.root.join('spec/support/pdf/Comprovante-teste.pdf'), 'application/pdf')

      post '/api/v1/receipts', params: { receipt: file }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Comprovante recebido com sucesso.')
      expect(Receipt.count).to eq(1)
      expect(Receipt.first.file).to be_attached
    end

    it 'cria um comprovante com um arquivo jpg anexado' do
      file = fixture_file_upload(Rails.root.join('spec/support/images/reuri.jpeg'), 'image/jpeg')

      post '/api/v1/receipts', params: { receipt: file }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Comprovante recebido com sucesso.')
      expect(Receipt.count).to eq(1)
      expect(Receipt.first.file).to be_attached
    end

    it 'cria um comprovante com um arquivo png anexado' do
      file = fixture_file_upload(Rails.root.join('spec/support/images/foto-do-angelo.png'), 'image/png')

      post '/api/v1/receipts', params: { receipt: file }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Comprovante recebido com sucesso.')
      expect(Receipt.count).to eq(1)
      expect(Receipt.first.file).to be_attached
    end
  end
end
