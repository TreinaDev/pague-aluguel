class PropertyOwners::SessionsController < Devise::SessionsController
  def create
    super do |resource|
      if resource.errors.any?
        render :new
        return
      end
    end
  end
end
