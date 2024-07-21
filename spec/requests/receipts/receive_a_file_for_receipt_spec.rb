require 'rails_helper'

RSpec.describe 'Comprovantes', type: :request do
  describe 'POST' do
    it 'cria um comprovante com um arquivo pdf anexado' do
      bill = create(:bill, id: 1)
      receipt = Receipt.new(bill:)
      receipt.file.attach(io: File.open('spec/support/pdf/Comprovante-teste.pdf'),
                          filename: 'Comprovante-teste.pdf', content_type: 'application/pdf')
      receipt.save!
      file_attached_blob = receipt.file.attachment.blob
      url = Rails.application.routes.url_helpers.rails_blob_url(file_attached_blob, host: 'localhost:4000')
      mocked_response = instance_double(Faraday::Response, success?: true,
                                                           body: File.read('spec/support/pdf/Comprovante-teste.pdf'),
                                                           headers: { 'content-type' => 'application/pdf' })
      allow(Receipt).to receive(:follow_redirects).with(url).and_return(mocked_response)

      receipt.destroy!
      post '/api/v1/receipts', params: { receipt: url, bill_id: '1' }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Comprovante recebido com sucesso.')
      expect(Receipt.count).to eq(1)
      expect(Receipt.first.file).to be_attached
      expect(Bill.find(bill.id).status).to eq 'awaiting'
    end

    it 'e fatura que estava com pagamento recusado muda o status' do
      bill = create(:bill, id: 1, denied: true)
      receipt = Receipt.new(bill:)
      receipt.file.attach(io: File.open('spec/support/pdf/Comprovante-teste.pdf'),
                          filename: 'Comprovante-teste.pdf', content_type: 'application/pdf')
      receipt.save!
      file_attached_blob = receipt.file.attachment.blob
      url = Rails.application.routes.url_helpers.rails_blob_url(file_attached_blob, host: 'localhost:4000')
      mocked_response = instance_double(Faraday::Response, success?: true,
                                                           body: File.read('spec/support/pdf/Comprovante-teste.pdf'),
                                                           headers: { 'content-type' => 'application/pdf' })
      allow(Receipt).to receive(:follow_redirects).with(url).and_return(mocked_response)

      receipt.destroy!
      post '/api/v1/receipts', params: { receipt: url, bill_id: '1' }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Comprovante recebido com sucesso.')
      expect(Receipt.count).to eq(1)
      expect(Receipt.first.file).to be_attached
      expect(Bill.find(bill.id).status).to eq 'awaiting'
      expect(Bill.find(bill.id).denied).to eq false
    end

    it 'cria um comprovante com um arquivo jpg anexado' do
      bill = create(:bill, id: 1)
      receipt = Receipt.new(bill:)
      receipt.file.attach(io: File.open('spec/support/images/reuri.jpeg'),
                          filename: 'Comprovante-teste.pdf', content_type: 'image/jpeg')
      receipt.save!
      file_attached_blob = receipt.file.attachment.blob
      url = Rails.application.routes.url_helpers.rails_blob_url(file_attached_blob, host: 'localhost:4000')
      mocked_response = instance_double(Faraday::Response, success?: true,
                                                           body: File.read('spec/support/images/reuri.jpeg'),
                                                           headers: { 'content-type' => 'image/jpeg' })
      allow(Receipt).to receive(:follow_redirects).with(url).and_return(mocked_response)

      receipt.destroy!
      post '/api/v1/receipts', params: { receipt: url, bill_id: '1' }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Comprovante recebido com sucesso.')
      expect(Receipt.count).to eq(1)
      expect(Receipt.first.file).to be_attached
      expect(Bill.find(bill.id).status).to eq 'awaiting'
    end

    it 'cria um comprovante com um arquivo png anexado' do
      bill = create(:bill, id: 1)
      receipt = Receipt.new(bill:)
      receipt.file.attach(io: File.open('spec/support/images/foto-do-angelo.png'),
                          filename: 'Comprovante-teste.pdf', content_type: 'image/png')
      receipt.save!
      file_attached_blob = receipt.file.attachment.blob
      url = Rails.application.routes.url_helpers.rails_blob_url(file_attached_blob, host: 'localhost:4000')
      mocked_response = instance_double(Faraday::Response, success?: true,
                                                           body: File.read('spec/support/images/foto-do-angelo.png'),
                                                           headers: { 'content-type' => 'image/png' })
      allow(Receipt).to receive(:follow_redirects).with(url).and_return(mocked_response)

      receipt.destroy!
      post '/api/v1/receipts', params: { receipt: url, bill_id: '1' }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Comprovante recebido com sucesso.')
      expect(Receipt.count).to eq(1)
      expect(Receipt.first.file).to be_attached
      expect(Bill.find(bill.id).status).to eq 'awaiting'
    end

    it 'retorna erro quando nenhum arquivo é enviado' do
      bill = create(:bill, id: 1)
      post '/api/v1/receipts', params: { receipt: nil, bill_id: '1' }

      expect(response).to have_http_status(:bad_request)
      expect(response.body).to include('Nenhum arquivo enviado.')
      expect(Receipt.count).to eq(0)
      expect(Bill.find(bill.id).status).to eq 'pending'
    end

    it 'retorna erro quando arquivo enviado não é um pdf, jpg ou png' do
      url = 'url_that_redirects_to/image.webp'
      mocked_response = instance_double(Faraday::Response, success?: true,
                                                           body: File.read('spec/support/images/best_game_ever.webp'),
                                                           headers: { 'content-type' => 'image/webp' })
      allow(Receipt).to receive(:follow_redirects).with(url).and_return(mocked_response)

      post '/api/v1/receipts', params: { receipt: url, bill_id: '1' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('O arquivo deve ser JPG, PNG ou PDF.')
      expect(Receipt.count).to eq(0)
    end

    it 'retorna erro quando o ID da fatura é inválido ou não é passado' do
      url = 'url_that_redirects_to/Comprovante-teste.pdf'
      mocked_response = instance_double(Faraday::Response, success?: true,
                                                           body: File.read('spec/support/pdf/Comprovante-teste.pdf'),
                                                           headers: { 'content-type' => 'application/pdf' })
      allow(Receipt).to receive(:follow_redirects).with(url).and_return(mocked_response)

      post '/api/v1/receipts', params: { receipt: url, bill_id: nil }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('ID da fatura não informado.')
      expect(Receipt.count).to eq(0)
    end
  end
end
