class NdCertificate < ApplicationRecord
  validates :unit_id, :issue_date, presence: true
end
