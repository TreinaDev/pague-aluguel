class UnitType
  attr_accessor :id, :area, :description, :ideal_fraction, :condo_id

  def initialize(id:, area:, description:, ideal_fraction:, condo_id:)
    @id = id
    @area = area
    @description = description
    @ideal_fraction = ideal_fraction
    @condo_id = condo_id
  end

  def self.all
    unit_types = []
    response = Faraday.get('http://127.0.0.1:3000/api/v1/unit_types')
    if response.success?
      data = JSON.parse(response.body)
      data.each do |ut|
        unit_types << UnitType.new(id: ut['id'], area: ut['area'], description: ut['description'],
                                   ideal_fraction: ut['ideal_fraction'], condo_id: ut['condo_id'])
      end
    end
    unit_types
  end

  def self.find(id)
    response = Faraday.get("http://127.0.0.1:3000/api/v1/unit_types/#{id}")
    if response.success?
      data = JSON.parse(response.body)
      unit_type = UnitType.new(id: data['id'],
                               area: data['area'],
                               description: data['description'],
                               ideal_fraction: data['ideal_fraction'],
                               condo_id: data['condo_id'])
    end
    unit_type
  end

  def self.find_all_by_condo(id)
    UnitType.all.filter { |ut| ut.condo_id == id }
  end
end
