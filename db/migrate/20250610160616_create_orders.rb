class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders, id: :uuid do |t|
      t.string :order_id, null: false
      t.string :merchant_reference, null: false
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.uuid :disbursement_id, index: true, null: true

      t.timestamps
    end

    add_index :orders, :order_id, unique: true
    add_foreign_key :orders, :merchants, column: :merchant_reference, primary_key: :reference
  end
end

