class AddStatusColumnToBills < ActiveRecord::Migration[7.1]
  def change
    add_column :bills, :status, :integer, null: false, default: 0
  end
end
