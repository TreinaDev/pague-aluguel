class CommonArea
  attr_accessor :id, :condo_id, :name, :description, :max_occupancy, :rules

  BASE_URL = 'http://127.0.0.1:3000/api/v1'.freeze

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
    response = Faraday.get("#{BASE_URL}/condos/#{condo_id}/common_areas")
    raise response.status.to_s unless response.success?

    data = JSON.parse(response.body, symbolize_names: true)
    common_areas_data = data[:common_areas]
    common_areas = common_areas_data.map do |common_area_attrs|
      CommonArea.new(common_area_attrs)
    end
    common_areas
  end

  def self.find(condo_id, id)
    response = Faraday.get("#{BASE_URL}/condos/#{condo_id}/common_areas/#{id}")
    raise response.status.to_s unless response.success?

    data = JSON.parse(response.body, symbolize_names: true)
    CommonArea.new(data)
  end
end
