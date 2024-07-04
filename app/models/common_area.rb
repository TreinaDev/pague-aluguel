class CommonArea
  def initialize(id:, condo_id:, name:, description:, max_occupancy:, rules:)
    @id = id
    @condo_id = condo_id
    @name = name
    @description = description
    @max_occupancy = max_occupancy
    @rules = rules
  end

  def self.find_by_condo_id(condo_id)
    common_areas = []
    base_url = 'http://127.0.0.1:3000/api/v1'
    response = Faraday.get("#{base_url}/condos/#{condo_id}/common_areas")
    if response.success?
      data = JSON.parse(response.body)
      data.each do |common_area|
        common_areas << generate_common_area(common_area, condo_id)
      end
    end
    common_areas
  end

  def self.generate_common_area(common_area, condo_id)
    CommonArea.new(
      id: common_area['id'],
      condo_id:,
      name: common_area['name'],
      description: common_area['description'],
      max_occupancy: common_area['max_occupancy'],
      rules: common_area['rules']
    )
  end
  # belongs_to :condo
  # validate :fee_not_negative, on: :update
  # validates :fee_cents, presence: true
  # validates :fee_cents, numericality: { only_integer: true }

  # has_many :common_area_fee_histories, dependent: :destroy

  # after_update :add_fee_to_history

  # monetize :fee_cents

  # private

  # def fee_not_negative
  #   errors.add(:fee_cents, ' não pode ser negativa.') if fee_cents&.negative?
  # end

  # def add_fee_to_history
  #   CommonAreaFeeHistory.create!(fee_cents:, common_area: self)
  # end
end
