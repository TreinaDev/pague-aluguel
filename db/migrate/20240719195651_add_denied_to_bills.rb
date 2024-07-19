class AddDeniedToBills < ActiveRecord::Migration[7.1]
  def change
    add_column :bills, :denied, :boolean, default: false
  end
end
