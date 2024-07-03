require 'rails_helper'

RSpec.describe PropertyOwner, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:document_id) }
  it { should validate_uniqueness_of(:document_id) }
end
