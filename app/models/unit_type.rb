class UnitType
  attr_accessor :id, :description, :metreage, :fraction, :unit_ids

  def initialize(attribute = {})
    @id = attribute[:id]
    @description = attribute[:description]
    @metreage = attribute[:metreage]
    @fraction = attribute[:fraction]
    @unit_ids = attribute[:unit_ids]
  end

  def self.all(condo_id)
    response = Faraday.get("#{Rails.configuration.api['base_url']}/condos/#{condo_id}/unit_types")
    unit_types = []
    return [] unless response.success?

    data = JSON.parse(response.body)
    data.map do |unit_type|
      unit_types << UnitType.new(id: unit_type['id'], description: unit_type['description'],
                                 metreage: unit_type['metreage'], fraction: unit_type['fraction'],
                                 unit_ids: unit_type['unit_ids'])
    end

    unit_types
  end
end
