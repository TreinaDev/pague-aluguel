class AddSuperAdminToAdmins < ActiveRecord::Migration[7.1]
  def change
    add_column :admins, :super_admin, :boolean, default: false
  end
end
