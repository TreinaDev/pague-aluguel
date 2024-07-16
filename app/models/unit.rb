class Unit
  attr_accessor :id, :area, :floor, :number, :unit_type_id, :condo_id, :tenant_id, :owner_id, :description, :condo_name

  def initialize(params = {})
    @id = params[:id]
    @area = params[:area]
    @floor = params[:floor]
    @number = params[:number]
    @unit_type_id = params[:unit_type_id]
    @tenant_id = params[:tenant_id]
    @owner_id = params[:owner_id]
    @owner_name = params[:owner_name]
    @description = params[:description]
    @condo_name = params[:condo_name]
  end

  def self.all
    units = []
    response = Faraday.get("#{Rails.configuration.api['base_url']}/units")
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
    response = Faraday.get("#{Rails.configuration.api['base_url']}/units/#{id}")
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

  def self.find_all_by_owner(cpf)
    response = Faraday.get("#{Rails.configuration.api['base_url']}/get_owner_properties?registration_number=#{cpf}")
    return unless response.success?

    data = JSON.parse(response.body)
    build_owner_units(data)
  end

  def identifier
    "#{floor}#{number}"
  end

  def set_status
    return I18n.t('views.show.owner_tenant') if owner_id == tenant_id

    return I18n.t('views.show.has_tenant') if tenant_id.present? && owner_id != tenant_id

    I18n.t('views.show.no_tenant')
  end

  def unit_has_tenant?
    tenant_id.present? && owner_id != tenant_id
  end

  def self.build_owner_units(data)
    data['properties'].map do |unit|
      Unit.new(id: unit['id'], area: unit['area'], floor: unit['floor'], number: unit['number'],
               unit_type_id: unit['unit_type_id'], condo_name: unit['condo_name'],
               tenant_id: unit['tenant_id'], owner_id: data['resident']['owner_id'],
               owner_name: data['resident']['name'], description: unit['description'])
    end
  end
end
