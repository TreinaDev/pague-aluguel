class CreateCommonAreaFeeHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :common_area_fee_histories do |t|
      t.integer :fee
      t.string :user
      t.references :common_area, null: false, foreign_key: true

      t.timestamps
    end
  end
end
