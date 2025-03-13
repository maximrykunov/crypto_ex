#!/bin/bash
set -e

# Запускаем миграции
bin/rails db:prepare

# Запускаем сервер
exec "$@"