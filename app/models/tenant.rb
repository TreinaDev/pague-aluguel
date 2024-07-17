class Tenant
  attr_accessor :name, :tenant_id, :residence, :document_number

  def initialize(resident = {})
    @name = resident[:name]
    @tenant_id = resident[:tenant_id]
    @residence = resident[:residence]
    @document_number = resident[:document_number]
  end

  def self.instance_from_api(response_body, document_number)
    data = JSON.parse(response_body)['resident']
    @tenant = Tenant.new(
      name: data['name'],
      tenant_id: data['tenant_id'],
      residence: data['residence'],
      document_number: 
    )
  end

  def self.find(document_number:)
    query = "get_tenant_residence?registration_number=#{document_number}"
    response = Faraday.get("#{Rails.configuration.api['base_url']}/#{query}")
    if response.success?
      self.instance_from_api(response.body, document_number)
    elsif response.status == 404
      raise DocumentNumberNotFoundError.new(I18n.t('views.index.document_number_not_found'))
    elsif response.status == 412
      raise DocumentNumberNotValidError.new(I18n.t('views.index.document_number_not_valid'))
    end
  end

  class DocumentNumberNotFoundError < StandardError; end
  class DocumentNumberNotValidError < StandardError; end
end
