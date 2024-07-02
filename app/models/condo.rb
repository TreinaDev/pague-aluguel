class Condo
  attr_accessor :id, :name, :city

  def initialize(id:, name:, city:)
    @id = id
    @name = name
    @city = city
  end

  def self.all
    condos = []
    response = Faraday.get('http://127.0.0.1:3000/api/v1/condos')
    if response.status == 200
      data = JSON.parse(response.body)
      data.each do |condo|
        condos << Condo.new(id: condo['id'], name: condo['name'], city: condo['city'])
      end
    end

    condos
  end
  # has_many :unit_types, dependent: :destroy
  # has_many :units, through: :unit_types
  # has_many :common_areas, dependent: :destroy
  # has_many :base_fees, dependent: :destroy
  # has_many :shared_fees, dependent: :destroy
end
