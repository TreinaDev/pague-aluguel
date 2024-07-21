require 'rails_helper'

RSpec.describe Receipt, type: :model do
  it { is_expected.to belong_to(:bill) }
  it { is_expected.to validate_presence_of(:file) }
  it { is_expected.to validate_attached_of(:file) }
  it { is_expected.to validate_size_of(:file).less_than(5.megabytes) }
  it { is_expected.to validate_content_type_of(:file).allowing('image/jpeg', 'image/png', 'application/pdf') }

  describe '.follow_redirects' do
    it 'follows redirects and returns the response' do
      url = 'http://some_url_that_redirects_to/test.pdf'

      connection = instance_double(Faraday::Connection)
      mocked_response = instance_double(Faraday::Response, success?: true, body: 'PDF content',
                                                           headers: { 'content-type' => 'application/pdf' })

      allow(Faraday).to receive(:new).and_yield(connection).and_return(connection)
      allow(connection).to receive(:response).with(:follow_redirects)
      allow(connection).to receive(:adapter).with(Faraday.default_adapter)
      allow(connection).to receive(:get).with(url).and_return(mocked_response)

      response = Receipt.follow_redirects(url)

      expect(response).to eq(mocked_response)
      expect(response.body).to eq('PDF content')
      expect(response.headers['content-type']).to eq('application/pdf')
    end
  end
end
