class Unit
  attr_accessor :id, :area, :floor, :number, :unit_type_id, :condo_id, :condo_name,
                :tenant_id, :owner_id, :description, :tower_name

  def initialize(attribute = {})
    @id = attribute[:id]
    @number = attribute[:number]
    @area = attribute[:area]
    @floor = attribute[:floor]
    @tower_name = attribute[:tower_name]
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

  def self.find_all_by_owner(document_number)
    registration_number = CPF.new(document_number).formatted
    response = Faraday.get(
      "#{Rails.configuration.api['base_url']}/get_owner_properties?registration_number=#{registration_number}"
    )
    return [] unless response.success?

    data = JSON.parse(response.body)
    build_owner_units(data)
  end

  def calculate_values(bill)
    base_fee, shared_fee, single_charge, rent_fee = create_bill_total_values(bill)
    bill.total_value_cents = sum_all_values(base_fee, shared_fee, single_charge, rent_fee)
    bill
  end

  def create_bill_total_values(bill)
    bill.base_fee_value_cents = BaseFeeCalculator.total_value(unit_type_id)
    bill.shared_fee_value_cents = BillCalculator.calculate_shared_fees(id)
    bill.single_charge_value_cents = BillCalculator.calculate_single_charges(id)
    bill.rent_fee_cents = BillCalculator.check_rent_fee(id)

    [bill.base_fee_value_cents,
     bill.shared_fee_value_cents,
     bill.single_charge_value_cents,
     bill.rent_fee_cents]
  end

  def sum_all_values(base_fee, shared_fee, single_charge, rent_fee)
    base_fee + shared_fee + single_charge + rent_fee
  end

  def set_status
    return I18n.t('messages.owner_tenant') if owner_id == tenant_id

    return I18n.t('messages.has_tenant') if tenant_id.present? && owner_id != tenant_id

    I18n.t('messages.available.rent')
  end

  def unit_has_tenant?
    tenant_id.present? && owner_id != tenant_id
  end

  def unit_rent_fee
    RentFee.find_by(unit_id: id)
  end

  def self.build_owner_units(data)
    data['resident']['properties'].map do |unit|
      Unit.new(id: unit['id'], area: unit['area'], floor: unit['floor'], number: unit['number'],
               unit_type_id: unit['unit_type_id'], condo_name: unit['condo_name'], condo_id: data['condo_id'],
               tenant_id: unit['tenant_id'], owner_id: data['resident']['owner_id'],
               description: unit['description'])
    end
  end

  def self.build_new_unit(data)
    Unit.new(id: data['id'], area: data['area'], floor: data['floor'], number: data['number'],
             unit_type_id: data['unit_type_id'], condo_id: data['condo_id'], condo_name: data['condo_name'],
             tenant_id: data['tenant_id'], owner_id: data['owner_id'],
             description: data['description'], tower_name: data['tower_name'])
  end
end
