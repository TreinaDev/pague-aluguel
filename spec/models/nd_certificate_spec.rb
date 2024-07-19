require 'rails_helper'

RSpec.describe NdCertificate, type: :model do
  it { should validate_presence_of(:unit_id) }
  it { should validate_presence_of(:issue_date) }
end
