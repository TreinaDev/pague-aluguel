module AdminHelper
  def capitalized_name(admin)
    "#{admin.first_name.titleize} #{admin.last_name.titleize}"
  end
end
