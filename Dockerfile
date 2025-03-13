FROM ruby:3.2.2

# Устанавливаем Node.js и Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

# Устанавливаем зависимости для PostgreSQL, ImageMagick и прочего
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev imagemagick

# Создаём директорию приложения
WORKDIR /app

# Копируем Gemfile и Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Устанавливаем зависимости через Bundler
RUN gem install bundler -v 2.6.5 && bundle install

# Копируем остальные файлы проекта
COPY . .

# Открываем порт для Puma
EXPOSE 3000

# Запуск сервера
CMD ["bin/rails", "server", "-b", "0.0.0.0"]

ENTRYPOINT ["./entrypoint.sh"]