class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :common_area_fees, dependent: :destroy
  has_many :associated_condos, dependent: :delete_all
  has_one_attached :photo

  validates :first_name, :last_name, presence: true
  validates :document_number, :email, :password, presence: true, on: :create
  validates :document_number, uniqueness: true
  validates :first_name, :last_name, length: { in: 3..20 }
  validates :document_number, length: { is: 11 }

  validate :verify_document_number

  before_save :downcase_name

  private

  def downcase_name
    self.first_name = first_name.downcase if first_name.present?
    self.last_name = last_name.downcase if last_name.present?
  end

  def verify_document_number
    errors.add(:document_number, I18n.t('errors.not_valid')) unless CPF.valid?(document_number)
  end
end
