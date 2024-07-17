module ApplicationHelper
  def array_length_greater_than?(array, min_length)
    array.length > min_length
  end

  def humanized_unit(unit_id)
    unit = Unit.find(unit_id)
    "Unidade #{unit.number}"
  end
end
