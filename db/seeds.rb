# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.find_or_create_by!(email_address: "admin@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.admin_role = true
end

user_1 = User.find_or_create_by!(email_address: "user_1@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end

user_2 = User.find_or_create_by!(email_address: "user_2@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end

# Generate orders
20.times do |idx|
  send_amount = rand(10..29)
  price = rand(5.1..5.3)
  commision = CommisionService.call(send_amount, price)

  attributes = {
    user_id: [ user_1.id, user_2.id ].sample,
    base_currency: Settings.base_currencies.first,
    base_address: Settings.usdt_wallet,
    quote_currency: Settings.quote_currencies.first,
    quote_address: "bc1qar0srrr8c4xywcrvdp7rkxw7y4f55q9k0pmd4d",
    send_amount: commision[:send_amount],
    receive_amount: commision[:receive_amount],
    fee: commision[:fee],
    miner_fee: commision[:miner_fee],
    price: commision[:price],
    status: rand(0..2)
  }

  Order.create!(attributes)
end
