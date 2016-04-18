FROM ruby:2.2.3

RUN mkdir -p /app
WORKDIR /app

COPY . /app
# RUN bundle install

