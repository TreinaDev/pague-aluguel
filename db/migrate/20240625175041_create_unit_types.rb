class CreateUnitTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :unit_types do |t|
      t.string :description
      t.integer :area
      t.float :ideal_fraction
      t.references :condo, null: false, foreign_key: true

      t.timestamps
    end
  end
end
