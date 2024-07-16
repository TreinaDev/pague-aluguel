class CommonArea
  attr_accessor :id, :condo_id, :name, :description, :max_occupancy, :rules

  def initialize(attribute = {})
    @id = attribute[:id]
    @condo_id = attribute[:condo_id]
    @name = attribute[:name]
    @description = attribute[:description]
    @max_occupancy = attribute[:max_occupancy]
    @rules = attribute[:rules]
  end

  def self.all(condo_id)
    common_areas = []
    response = Faraday.get("#{Rails.configuration.api['base_url']}/condos/#{condo_id}/common_areas")
    raise response.status.to_s unless response.success?

    data = JSON.parse(response.body, symbolize_names: true)
    data[:common_areas].map do |common_area|
      common_areas << CommonArea.new(common_area)
    end
    common_areas
  end

  def self.find(id)
    response = Faraday.get("#{Rails.configuration.api['base_url']}/common_areas/#{id}")
    raise response.status.to_s unless response.success?

    data = JSON.parse(response.body, symbolize_names: true)
    data[:id] = id
    CommonArea.new(data)
  end
end
