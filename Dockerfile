ARG RUBY_VERSION=3.3.1
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends build-essential libpq-dev pkg-config

ENV RAILS_ENV="development" \
    BUNDLE_DEPLOYMENT="0" \
    BUNDLE_PATH="/usr/local/bundle"

COPY Gemfile Gemfile.lock ./

RUN bundle lock --add-platform aarch64-linux && \
    bundle install

COPY . .

EXPOSE 3000

ENTRYPOINT ["bash", "bin/docker-entrypoint"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]