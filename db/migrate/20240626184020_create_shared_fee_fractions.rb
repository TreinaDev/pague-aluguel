class CreateSharedFeeFractions < ActiveRecord::Migration[7.1]
  def change
    create_table :shared_fee_fractions do |t|
      t.integer :value
      t.references :shared_fee, null: false, foreign_key: true
      t.references :unit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
