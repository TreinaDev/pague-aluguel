class Condo
  attr_accessor :id, :name, :city

  def initialize(id:, name:, city:)
    @id = id
    @name = name
    @city = city
  end

  def self.all
    condos = []
    response = Faraday.get("#{Rails.configuration.api['base_url']}/condos")
    if response.success?
      data = JSON.parse(response.body)
      data.each do |condo|
        condos << Condo.new(id: condo['id'], name: condo['name'], city: condo['city'])
      end
    end

    condos
  end

  def self.find(id)
    response = Faraday.get("#{Rails.configuration.api['base_url']}/condos/#{id}")
    if response.success?
      data = JSON.parse(response.body)
      condo = Condo.new(id: data['id'], name: data['name'], city: data['city'])
    end
    condo
  end
end
