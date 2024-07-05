class RenameFixedFromBaseFees < ActiveRecord::Migration[7.1]
  def change
    rename_column :base_fees, :fixed, :limited
  end
end
