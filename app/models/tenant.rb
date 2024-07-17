class Tenant
  attr_accessor :name, :tenant_id, :residence, :document_number

  def initialize(resident = {})
    @name = resident[:name]
    @tenant_id = resident[:tenant_id]
    @residence = resident[:residence]
    @document_number = resident[:document_number]
  end

  def self.find(document_number:)
    query = "get_tenant_residence?registration_number=#{document_number}"
    response = Faraday.get("#{Rails.configuration.api['base_url']}/#{query}")

    if response.success?
      data = JSON.parse(response.body)['resident']
      tenant = Tenant.new(name: data['name'], tenant_id: data['tenant_id'], residence: data['residence'], document_number: document_number)
    end
    tenant
  end
end
