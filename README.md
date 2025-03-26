# README

# Crypto Ex
/admin - admin interface
/orders/new - new exchange order. Get real price from coinmarketcap
/users/:id - list of all users orders

## Build with docker
  * docker-compose up --build
  * docker-compose run --rm web bin/rails assets:precompile
  * docker-compose run --rm web bin/rails db:create
  * docker-compose run --rm web bin/rails db:migrate
  * docker-compose run --rm web bin/rails db:seed

## Seed details
Generate 1 admin user and 2 regular users. 
Generate orders. 

