class AddNameToPropertyOwner < ActiveRecord::Migration[7.1]
  def change
    add_column :property_owners, :first_name, :string
    add_column :property_owners, :last_name, :string
  end
end
