require 'rails_helper'

RSpec.describe Receipt, type: :model do
  it { is_expected.to validate_presence_of(:file) }
  it { is_expected.to validate_attached_of(:file) }
  it { is_expected.to validate_size_of(:file).less_than(5.megabytes) }
  it { is_expected.to validate_content_type_of(:file).allowing('image/jpeg', 'image/png', 'application/pdf') }
end
