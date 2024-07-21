class BillCalculator
  def self.generate_bill_details(bill)
    shared_fees = get_last_month_fractions(bill.unit_id)
    single_charges = get_last_month_single_charges(bill.unit_id)

    process_fees(shared_fees, bill)
    process_charges(single_charges, bill)
  end

  def self.process_fees(shared_fees, bill)
    shared_fees.each do |fee|
      BillDetail.create!(bill_id: bill.id, description: fee.shared_fee.description,
                         value_cents: fee.value_cents, fee_type: :shared_fee)
    end
    BaseFeeCalculator.generate_base_fee_details(bill, Unit.find(bill.unit_id).unit_type_id)
  end

  def self.process_charges(single_charges, bill)
    single_charges.each do |charge|
      if charge.common_area_fee?
        BillDetail.create!(bill_id: bill.id, description: CommonArea.find(charge.common_area_id).name,
                           value_cents: charge.value_cents, fee_type: charge.charge_type)

      else
        BillDetail.create!(bill_id: bill.id, description: charge.description,
                           value_cents: charge.value_cents, fee_type: charge.charge_type)
      end
    end
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
