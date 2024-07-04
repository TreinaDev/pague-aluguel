class RemoveCondoReferenceFromBaseFee < ActiveRecord::Migration[7.1]
  def change
    remove_reference :base_fees, :condo, index: true, foreign_key: true
  end
end
