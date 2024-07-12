class Unit
  attr_accessor :id, :area, :floor, :number, :unit_type_id

  def initialize(id:, area:, floor:, number:, unit_type_id:)
    @id = id
    @area = area
    @floor = floor
    @number = number
    @unit_type_id = unit_type_id
  end

  def self.all
    units = []
    response = Faraday.get('http://127.0.0.1:3000/api/v1/units')
    if response.success?
      data = JSON.parse(response.body)
      data.each do |unit|
        units << Unit.new(id: unit['id'], area: unit['area'], floor: unit['floor'], number: unit['number'],
                          unit_type_id: unit['unit_type_id'])
      end
    end
    units
  end

  def self.find(id)
    response = Faraday.get("http://127.0.0.1:3000/api/v1/units/#{id}")
    if response.success?
      data = JSON.parse(response.body)
      unit = Unit.new(id: data['id'], area: data['area'], floor: data['floor'], number: data['number'],
                      unit_type_id: data['unit_type_id'])
    end
    unit
  end

  def self.find_all_by_condo(id)
    unit_types = UnitType.find_all_by_condo(id)
    unit_type_ids = unit_types.map(&:id)
    Unit.all.select { |unit| unit_type_ids.include?(unit.unit_type_id) }
  end
end
