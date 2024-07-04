class DropCommonAreas < ActiveRecord::Migration[7.1]
  def change
    drop_table :common_areas
  end
end
