class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :order_type, null: false, default: 0  # limit, market
      t.integer :order_side, null: false, default: 0  # buy, sell
      t.string :base_currency, null: false
      t.string :base_address, null: false
      t.string :quote_currency, null: false
      t.string :quote_address, null: false
      t.decimal :send_amount, precision: 20, scale: 8, null: false
      t.decimal :receive_amount, precision: 20, scale: 8, null: false
      t.decimal :price, precision: 20, scale: 8, null: false
      t.decimal :fee, precision: 20, scale: 8, null: false
      t.decimal :miner_fee, precision: 20, scale: 8, null: false
      t.integer :status, null: false, default: 0  # pending, completed, cancelled
      t.timestamps
    end
  end
end
