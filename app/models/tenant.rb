class Tenant
  attr_accessor :name, :tenant_id, :residence

  def initialize(resident = {})
    @name = resident[:name]
    @tenant_id = resident[:tenant_id]
    @residence = resident[:residence]
  end

  def self.find(document_number:)
    query = "get_tenant_residence?registration_number={#{document_number}}"
    response = Faraday.get("#{Rails.configuration.api['base_url']}/#{query}")

    if response.success?
      data = JSON.parse(response.body)['resident']
      tenant = Tenant.new(name: data['name'], tenant_id: data['tenant_id'], residence: data['residence'])
    end
    tenant
  end
end
