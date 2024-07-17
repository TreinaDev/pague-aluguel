class UnitType
  attr_accessor :id, :description, :metreage, :fraction, :unit_ids, :condo_id

  def initialize(attribute = {})
    @id = attribute[:id]
    @description = attribute[:description]
    @metreage = attribute[:metreage]
    @fraction = attribute[:fraction]
    @unit_ids = attribute[:unit_ids]
    @condo_id = attribute[:condo_id]
  end

  def self.all(condo_id)
    response = Faraday.get("#{Rails.configuration.api['base_url']}/condos/#{condo_id}/unit_types")
    unit_types = []
    return [] unless response.success?

    data = JSON.parse(response.body, symbolize_names: true)
    data.map do |unit_type|
      unit_type[:condo_id] = condo_id
      unit_types << UnitType.new(unit_type)
    end

    unit_types
  end
end
