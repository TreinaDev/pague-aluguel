module SingleChargeHelper
  def category_options(condo_id)
    if CommonArea.all(condo_id).empty?
      SingleCharge.charge_types.except(:common_area_fee).map do |key, _|
        [I18n.t("single_charge.#{key}"), key]
      end
    else
      SingleCharge.charge_types.map do |key, _|
        [I18n.t("single_charge.#{key}"), key]
      end
    end
  end

  def owner_category_options
    SingleCharge.charge_types.except(:common_area_fee).map do |key, _|
      [I18n.t("single_charge.#{key}"), key]
    end
  end
end
