class Tenant
  attr_accessor :name, :tenant_id, :residence, :document_number, :tower_name

  def initialize(resident = {})
    @name = resident[:name]
    @tenant_id = resident[:tenant_id]
    @residence = resident[:residence]
    @document_number = resident[:document_number]
    @tower_name = resident[:tower_name]
  end

  def self.instance_from_api(response_body, document_number)
    data = JSON.parse(response_body)['resident']
    @tenant = Tenant.new(
      name: data['name'],
      tenant_id: data['tenant_id'],
      residence: data['residence'],
      tower_name: data['tower_name'],
      document_number:
    )
  end

  def self.find(document_number:)
    query = "get_tenant_residence?registration_number=#{document_number}"
    response = Faraday.get("#{Rails.configuration.api['base_url']}/#{query}")

    if response.success?
      instance_from_api(response.body, document_number)
    elsif response.status == 404
      raise DocumentNumberNotFoundError, I18n.t('errors.not_found.document')
    elsif response.status == 412
      raise DocumentNumberNotValidError, I18n.t('errors.invalid.document')
    end
  end

  class DocumentNumberNotFoundError < StandardError; end
  class DocumentNumberNotValidError < StandardError; end
end
