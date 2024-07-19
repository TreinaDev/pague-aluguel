class CreateNdCertificates < ActiveRecord::Migration[7.1]
  def change
    create_table :nd_certificates do |t|
      t.integer :unit_id
      t.datetime :issue_date

      t.timestamps
    end
  end
end
