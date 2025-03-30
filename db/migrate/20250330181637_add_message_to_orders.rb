class AddMessageToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :message, :string
  end
end
