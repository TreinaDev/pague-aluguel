module AdminHelper
  def capitalized_name(admin)
    "#{admin.first_name.titleize} #{admin.last_name.titleize}"
  end

  def avatar(admin)
    if admin.photo.attached?
      image_tag admin.photo, class: 'avatar me-3'
    else
      image_tag 'psycho-user', class: 'avatar me-3'
    end
  end

  def profile_avatar(admin)
    if admin.photo.attached?
      image_tag admin.photo, class: 'profile-avatar me-3'
    else
      image_tag 'psycho-user', class: 'profile-avatar me-3'
    end
  end

  def associated_condos_names(admin)
    valid_associations = admin.associated_condos.select { |ac| ac.condo_id.present? }
    valid_associations.map { |association| Condo.find(association.condo_id).name }
  end
end
