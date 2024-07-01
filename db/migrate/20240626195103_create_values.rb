class CreateValues < ActiveRecord::Migration[7.1]
  def change
    create_table :values do |t|
      t.references :base_fee, null: false, foreign_key: true
      t.references :unit_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
