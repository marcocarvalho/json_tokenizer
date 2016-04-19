FROM ruby:2.2.3

RUN mkdir -p /app
WORKDIR /app

RUN apt-get update && apt-get install -y fpc

COPY . /app
RUN bundle install

