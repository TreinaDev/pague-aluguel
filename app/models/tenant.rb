class Tenant
  attr_accessor :document_number

  def initialize(resident = {})
    @name = resident[:name]
    @tenant_id = resident[:tenant_id]
    # @unit_id = resident[:residence][:id]
    # @condo_id = resident[:residence][:condo_id]
    # @unit = Unit.find(@unit_id)
    @residence = resident[:residence]
  end

  def self.find(document_number:)
    query = "get_tenant_residence?registration_number={#{document_number}}"
    response = Faraday.get("#{Rails.configuration.api['base_url']}/#{query}")

    if response.success?
      data = JSON.parse(response.body)
      tenant = Tenant.new(name: data['name'], tenant_id: data['tenant_id'], residence: data['residence'])
    end
    tenant
  end
end
