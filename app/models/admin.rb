class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :document_number, :email, :password, presence: true
  validates :document_number, uniqueness: true
  validates :first_name, :last_name, length: { in: 3..20 }
  validates :document_number, length: { is: 11 }

  validate :verify_document_number

  private

  def verify_document_number
    errors.add(:document_number, 'não é válido') unless CPF.valid?(document_number, strict: true)
  end
end
