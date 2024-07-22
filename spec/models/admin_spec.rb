# spec/models/admin_spec.rb

require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:document_number) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_uniqueness_of(:document_number) }
    it { should validate_length_of(:document_number) }
    it { should validate_length_of(:first_name) }
    it { should validate_length_of(:last_name) }
  end

  describe '#downcase_name' do
    it 'deve converter o nome para minúsculas' do
      admin = Admin.create!(
        first_name: 'Harry',
        last_name: 'Potter',
        email: 'harryp@mail.com',
        document_number: CPF.generate,
        password: 'password123'
      )

      expect(admin.first_name).to eq 'harry'
      expect(admin.last_name).to eq 'potter'
    end
  end

  describe '#format' do
    it 'email - sem @' do
      admin = Admin.new(email: 'abcabc.com')

      admin.valid?
      result = admin.errors.include?(:email)

      expect(result).to be true
    end
  end

  describe '#uniqueness' do
    it 'de CPF' do
      @cpf = CPF.generate
      Admin.create!(
        first_name: 'Harry',
        last_name: 'Potter',
        email: 'harryp@mail.com',
        document_number: @cpf,
        password: 'password123'
      )
      admin = Admin.new(document_number: @cpf)

      admin.valid?
      result = admin.errors.include?(:document_number)

      expect(result).to be true
    end

    it 'de email' do
      @cpf = CPF.generate
      Admin.create!(
        first_name: 'Harry',
        last_name: 'Potter',
        email: 'harryp@mail.com',
        document_number: @cpf,
        password: 'password123'
      )
      admin = Admin.new(email: 'harryp@mail.com')

      admin.valid?
      result = admin.errors.include?(:email)

      expect(result).to be true
    end
  end

  describe '#verify_document_number' do
    it 'quando valor não é válido' do
      admin = Admin.new(document_number: '66666666666')

      admin.valid?
      result = admin.errors.include?(:document_number)

      expect(result).to be true
      expect(admin.errors[:document_number]).to include 'não é válido.'
    end
  end

  describe '#length' do
    it 'de CPF - muito curto' do
      admin = Admin.new(document_number: '1234567')

      admin.valid?
      result = admin.errors.include?(:document_number)

      expect(result).to be true
    end

    it 'de CPF - muito longo' do
      admin = Admin.new(document_number: '12345678901234')

      admin.valid?
      result = admin.errors.include?(:document_number)

      expect(result).to be true
    end

    it 'de nome - muito curto' do
      admin = Admin.new(first_name: 'aa')

      admin.valid?
      result = admin.errors.include?(:first_name)

      expect(result).to be true
    end

    it 'de nome - muito longo' do
      admin = Admin.new(first_name: 'otorinolaringologista')

      admin.valid?
      result = admin.errors.include?(:first_name)

      expect(result).to be true
    end

    it 'de sobrenome - muito curto' do
      admin = Admin.new(last_name: 'aa')

      admin.valid?
      result = admin.errors.include?(:last_name)

      expect(result).to be true
    end

    it 'de sobrenome - muito longo' do
      admin = Admin.new(last_name: 'otorinolaringologista')

      admin.valid?
      result = admin.errors.include?(:last_name)

      expect(result).to be true
    end
  end
end
