class CreateMerchants < ActiveRecord::Migration[8.0]
  def change
    create_table :merchants, id: :uuid do |t|
      t.string :reference, null: false
      t.string :email, null: false
      t.date :live_on
      t.string :disbursement_frequency, null: false
      t.decimal :minimum_monthly_fee, precision: 10, scale: 2, default: 0.0, null: false

      t.timestamps
    end

    add_index :merchants, :reference, unique: true
  end
end