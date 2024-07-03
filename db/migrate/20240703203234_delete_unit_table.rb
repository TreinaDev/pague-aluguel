class DeleteUnitTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :units
  end
end
