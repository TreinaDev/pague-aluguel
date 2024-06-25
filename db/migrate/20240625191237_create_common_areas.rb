class CreateCommonAreas < ActiveRecord::Migration[7.1]
  def change
    create_table :common_areas do |t|
      t.string :name
      t.string :description
      t.integer :max_capacity
      t.string :usage_rules
      t.decimal :fee
      t.references :condo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
