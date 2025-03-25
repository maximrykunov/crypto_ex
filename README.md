# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
# Crypto Ex
docker-compose up --build
docker-compose run --rm web bin/rails assets:precompile
docker-compose run --rm web bin/rails db:create
docker-compose run --rm web bin/rails db:migrate
docker-compose run --rm web bin/rails db:seed

docker-compose run --rm web bin/rails console
