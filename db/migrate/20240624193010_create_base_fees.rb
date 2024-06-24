class CreateBaseFees < ActiveRecord::Migration[7.1]
  def change
    create_table :base_fees do |t|
      t.decimal :value
      t.string :description

      t.timestamps
    end
  end
end
