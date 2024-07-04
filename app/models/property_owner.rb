class PropertyOwner < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :document_id, presence: true
  validates :document_id, uniqueness: true
  validate :document_id_must_be_valid

  private

  def document_id_must_be_valid
    return if cpf_valid?(document_id)

    errors.add(:document_id, :invalid, message: I18n.t('devise.failure.invalid_document_id'))
  end

  def cpf_valid?(cpf)
    url = "http://localhost:3000/api/v1/property?cpf=#{cpf}"
    response = Faraday.get(url)
    return true if response.status == 200

    false
  end
end
