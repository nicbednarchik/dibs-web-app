# syntax=docker/dockerfile:1

# Match your local Ruby (you said 3.4.5)
ARG RUBY_VERSION=3.4.5
FROM ruby:${RUBY_VERSION}-slim AS base

# Rails app lives here
WORKDIR /rails

# Runtime deps (Postgres client libs, image processing, jemalloc)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl libjemalloc2 libvips libpq5 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Production env + Bundler settings
ENV RAILS_ENV=production \
    RACK_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development:test" \
    RAILS_LOG_TO_STDOUT=1 \
    RAILS_SERVE_STATIC_FILES=1 \
    PORT=8080

# -------- Build stage: installs build tools + gems and precompiles assets --------
FROM base AS build

# Build tools + headers for native gems (pg)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential git libpq-dev libyaml-dev pkg-config libpq-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# App source
COPY . .

# Bootsnap + asset precompile (SECRET_KEY_BASE not needed with dummy)
RUN bundle exec bootsnap precompile app/ lib/
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# -------- Final runtime image --------
FROM base

# Bring in gems and app
COPY --from=build ${BUNDLE_PATH} ${BUNDLE_PATH}
COPY --from=build /rails /rails

# Keep Rails' entrypoint so it runs db:prepare, etc.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Listen on the platform port and all interfaces
EXPOSE 8080
CMD ["/bin/sh","-lc","./bin/rails server -b 0.0.0.0 -p ${PORT}"]
