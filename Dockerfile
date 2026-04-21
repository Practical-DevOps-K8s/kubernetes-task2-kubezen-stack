ARG RUBY_VERSION=3.3.1
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends build-essential libpq-dev pkg-config

ENV RAILS_ENV="development" \
    BUNDLE_DEPLOYMENT="0" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

COPY Gemfile Gemfile.lock ./

RUN bundle lock --add-platform aarch64-linux && \
    bundle install

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-b", "0.0.0.0", "-p", "3000", "-C", "config/puma.rb"]