class Condo
  attr_accessor :id, :name, :registration_number, :city, :state, :public_place, :number, :neighborhood, :zip

  def initialize(id:, name:, registration_number: nil, city:, state: nil, public_place: nil, number: nil, neighborhood: nil, zip: nil)
    @id = id
    @name = name
    @registration_number = registration_number
    @city = city
    @state = state
    @public_place = public_place
    @number = number
    @neighborhood = neighborhood
    @zip = zip
  end

  def self.all
    condos = []
    response = Faraday.get('http://127.0.0.1:3000/api/v1/condos')
    if response.success?
      data = JSON.parse(response.body)
      data.each do |condo|
        condos << Condo.new(id: condo['id'], name: condo['name'], city: condo['city'], state: condo['state'])
      end
    end

    condos
  end

  def self.find(id)
    response = Faraday.get("http://127.0.0.1:3000/api/v1/condos/#{id}")
    if response.success?
      data = JSON.parse(response.body)
      address = data['address']
      condo = Condo.new(id: data['id'], name: data['name'], registration_number: data['registration_number'], 
                        city: address['city'], state: address['state'], public_place: address['public_place'],
                        number: address['number'], neighborhood: address['neighborhood'], zip: address['zip'])
    end
    condo
  end
end
