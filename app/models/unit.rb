class Unit
  attr_accessor :id, :area, :floor, :number, :unit_type_id, :condo_id, :condo_name, :tenant_id, :owner_id, :description

  def initialize(attribute = {})
    @id = attribute[:id]
    @area = attribute[:area]
    @floor = attribute[:floor]
    @number = attribute[:number]
    @unit_type_id = attribute[:unit_type_id]
    @condo_id = attribute[:condo_id]
    @condo_name = attribute[:condo_name]
    @tenant_id = attribute[:tenant_id]
    @owner_id = attribute[:owner_id]
    @description = attribute[:description]
  end

  def self.all(condo_id)
    units = []
    response = Faraday.get("#{Rails.configuration.api['base_url']}/condos/#{condo_id}/units")

    if response.success?
      data = JSON.parse(response.body, symbolize_names: true)
      data[:units].map do |unit|
        units << Unit.new(unit)
      end
    end
    units
  end

  def self.find(unit_id)
    response = Faraday.get("#{Rails.configuration.api['base_url']}/units/#{unit_id}")
    return [] unless response.success?

    data = JSON.parse(response.body)
    build_new_unit(data)
  end

  def self.find_all_by_owner(cpf)
    response = Faraday.get("#{Rails.configuration.api['base_url']}/units/cpf=#{cpf}")
    units = []
    if response.success?
      data = JSON.parse(response.body)
      units_ids = data['units']
      units_ids.each do |id|
        units << Unit.find(id.to_i)
      end
    end
    units
  end

  def self.build_new_unit(data)
    Unit.new(id: data['id'], area: data['area'], floor: data['floor'], number: data['number'],
             unit_type_id: data['unit_type_id'], condo_id: data['condo_id'], condo_name: data['condo_name'],
             tenant_id: data['tenant_id'], owner_id: data['owner_id'], description: data['description'])
  end
end
