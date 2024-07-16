class AddCondoIdToBills < ActiveRecord::Migration[7.1]
  def change
    add_column :bills, :condo_id, :integer, null: false
  end
end
