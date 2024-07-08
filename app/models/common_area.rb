class CommonArea
  attr_accessor :id, :name, :description, :max_occupancy, :rules

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
    base_url = 'http://127.0.0.1:3000/api/v1'
    response = Faraday.get("#{base_url}/condos/#{condo_id}/common_areas")
    if response.success?
      data = JSON.parse(response.body)
      data.each do |common_area|
        common_areas << generate_common_area(common_area, condo_id)
      end
    end
    common_areas
  end

  def self.find(condo_id, id)
    base_url = 'http://127.0.0.1:3000/api/v1'
    response = Faraday.get("#{base_url}/condos/#{condo_id}/common_areas/#{id}")
    raise response.status.to_s unless response.success?

    data = JSON.parse(response.body)
    generate_common_area(data, condo_id)
  end

  def self.generate_common_area(common_area, condo_id)
    CommonArea.new({
                     id: common_area['id'],
                     condo_id:,
                     name: common_area['name'],
                     description: common_area['description'],
                     max_occupancy: common_area['max_occupancy'],
                     rules: common_area['rules']
                   })
  end
end
