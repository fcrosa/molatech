class CreateDisbursements < ActiveRecord::Migration[8.0]
  def change
    create_table :disbursements, id: :uuid do |t|
      t.string :reference, null: false
      t.string :merchant_reference, null: false
      t.date :disbursed_on, null: false
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.decimal :commission, precision: 12, scale: 2, null: false

      t.timestamps
    end

    add_index :disbursements, :reference, unique: true
    add_foreign_key :disbursements, :merchants, column: :merchant_reference, primary_key: :reference
  end
end
