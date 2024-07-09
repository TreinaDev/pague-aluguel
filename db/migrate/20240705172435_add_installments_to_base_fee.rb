class AddInstallmentsToBaseFee < ActiveRecord::Migration[7.1]
  def change
    add_column :base_fees, :installments, :integer
  end
end
