class Condo
  attr_accessor :id, :name, :city, :registration_number, :state, :public_place, :number, :neighborhood, :zip

  def initialize(attribute = {})
    @id = attribute[:id]
    @name = attribute[:name]
    @registration_number = attribute[:registration_number]
    @city = attribute[:city]
    @state = attribute[:state]
    @public_place = attribute[:public_place]
    @number = attribute[:number]
    @neighborhood = attribute[:neighborhood]
    @zip = attribute[:zip]
  end

  def self.all
    condos = []
    response = Faraday.get("#{Rails.configuration.api['base_url']}/condos")
    if response.success?
      data = JSON.parse(response.body, symbolize_names: true)
      data.each do |condo|
        condos << Condo.new(condo)
      end
    end
    condos
  end

  def self.find(id)
    response = Faraday.get("#{Rails.configuration.api['base_url']}/condos/#{id}")
    raise response.status unless response.success?

    instance_from_api(response.body, id)
  end

  def self.instance_from_api(response_body, id)
    data = JSON.parse(response_body, symbolize_names: true)
    address = data[:address]
    Condo.new(id:, name: data[:name], registration_number: data[:registration_number],
              city: address[:city], state: address[:state], public_place: address[:public_place],
              number: address[:number], neighborhood: address[:neighborhood], zip: address[:zip])
  end
end
