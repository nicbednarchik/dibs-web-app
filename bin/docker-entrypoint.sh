#!/usr/bin/env bash
set -e

# Ensure production; Render sets this in env but this is safe.
export RAILS_ENV=${RAILS_ENV:-production}

# Run migrations/schema setup idempotently
bundle exec rails db:prepare

# If you don’t have a separate Solid Queue worker yet, consider async:
# (comment this out once you add a worker service)
# export RAILS_ACTIVE_JOB_INLINE_ONLY=true

# Boot the web server
exec bundle exec puma -C config/puma.rb
# or: exec bin/rails server
