class CreateCommonAreaFees < ActiveRecord::Migration[7.1]
  def change
    create_table :common_area_fees do |t|
      t.integer :value_cents
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
