class RemoveCondoReferenceFromSharedFee < ActiveRecord::Migration[7.1]
  def change
    remove_reference :shared_fees, :condo, null: false, foreign_key: true
  end
end
