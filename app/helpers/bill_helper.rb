module BillHelper
  def unit_name(bill)
    unit = Unit.find(bill.unit_id)
    unit_name = "Unidade #{unit.floor}#{unit.number}"
  end
end
