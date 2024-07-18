class BillCalculator
  def self.calculate_total_fees(unit)
    base_fees = BaseFeeCalculator.total_value(unit.unit_type_id)
    shared_fees = calculate_shared_fees(unit.id)
    single_charges = calculate_single_charges(unit.id)
    rent_fee = check_rent_fee(unit.id)
    base_fees + shared_fees + single_charges + rent_fee
  end

  def self.calculate_shared_fees(unit_id)
    total_value = 0
    fractions = get_last_month_fractions(unit_id)
    fractions.each do |fraction|
      total_value += fraction.value_cents
    end
    total_value
  end

  def self.calculate_single_charges(unit_id)
    total_value = 0
    charges = get_last_month_single_charges(unit_id)
    charges.each do |charge|
      total_value += charge.value_cents
    end
    total_value
  end

  def self.get_last_month_fractions(unit_id)
    now = Time.zone.now
    last_month = now.last_month
    start_of_last_month = last_month.beginning_of_month
    end_of_last_month = last_month.end_of_month
    SharedFeeFraction.where(unit_id:)
                     .joins(:shared_fee)
                     .where(shared_fees: { issue_date: ...now })
                     .where(shared_fees: { issue_date: start_of_last_month..end_of_last_month })
                     .where(shared_fees: { status: :active })
  end

  def self.get_last_month_single_charges(unit_id)
    now = Time.zone.now
    last_month = now.last_month
    start_of_last_month = last_month.beginning_of_month
    end_of_last_month = last_month.end_of_month
    SingleCharge.where(unit_id:, issue_date: start_of_last_month..end_of_last_month, status: :active)
  end

  def self.check_rent_fee(unit_id)
    rent_fee = get_last_month_rent_fee(unit_id)
    rent_fee&.value_cents || 0
  end

  def self.get_last_month_rent_fee(unit_id)
    now = Time.zone.now
    last_month = now.last_month
    start_of_last_month = last_month.beginning_of_month
    end_of_last_month = last_month.end_of_month
    RentFee.find_by(unit_id:, issue_date: start_of_last_month..end_of_last_month, status: :active)
  end

  private_class_method :get_last_month_fractions, :get_last_month_single_charges, :get_last_month_rent_fee
end
