class ChangeLimitedFromBaseFees < ActiveRecord::Migration[7.1]
  def change
    change_column :base_fees, :limited, :boolean, default: false
  end
end
