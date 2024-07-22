class PropertyOwner < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :photo

  validates :document_number, :first_name, :last_name, presence: true
  validates :document_number, uniqueness: true
  validate :document_number_must_be_valid

  private

  def document_number_must_be_valid
    return if document_number_valid?(document_number)

    errors.add(:document_number, :invalid, message: I18n.t('errors.not_found.document_number'))
  end

  def document_number_valid?(document_number)
    return false if document_number.blank?

    registration_number = CPF.new(document_number).formatted
    url = "#{Rails.configuration.api['base_url']}/check_owner?registration_number=#{registration_number}"
    response = Faraday.get(url)
    response.success?
  end
end
