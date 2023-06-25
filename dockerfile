FROM ruby:3.2.1

RUN apt-get update && \
    apt-get install -y build-essential && \
    apt-get install -y libpq-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN gem install bundler

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000
RUN rails db:migrate
CMD ["rails", "server", "-b", "0.0.0.0"]
