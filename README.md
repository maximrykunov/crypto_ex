# README

# Crypto Ex
/admin - admin interface
/orders/new - new exchange order. Get real price from coinmarketcap
/users/:id - list of all users orders

У пользователя есть свой USDT кошелек, и ему надо перевести средства на SBTC внешний кошелек.
Пользователь создает order.
Создается транзакция перевод активов с его USDT кошелька на кошелек обменника. (Не делал в рамках этого проекта)
Создается транзакция перевод активов с SBTC кошелька обменника на внешний кошелек.
Система переиодически опрашивает ордера в статусе pending и проверяет количество confirmations.
Всего система делает 10 запросов и если не получает подтверждение транзакции то меняет статус заказа на cancelled
При получении подтверждения транзакции меняет статус заказа на completed.

## Build with docker
  * docker-compose up --build
  * docker-compose run --rm web bin/rails assets:precompile
  * docker-compose run --rm web bin/rails db:create
  * docker-compose run --rm web bin/rails db:migrate
  * docker-compose run --rm web bin/rails db:seed

## Seed details
Generate 1 admin user and 2 regular users. 
Generate orders. 

