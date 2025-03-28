class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :order, null: false, foreign_key: true
      t.string :txid, index: true
      t.integer :confirmations, default: 0

      t.timestamps
    end
  end
end
