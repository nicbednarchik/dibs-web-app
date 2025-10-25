# Gemfile
source "https://rubygems.org"

ruby File.read(".ruby-version").strip rescue nil

gem "rails", "~> 8.1.0"
gem "propshaft"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[windows jruby]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "image_processing", "~> 1.2"
gem "tailwindcss-rails", "~> 4.3"
gem "devise", "~> 4.9"

group :development, :test do
  # SQLite locally for easy setup (Rails 8 needs sqlite3 >= 2.1)
  gem "sqlite3", "~> 2.1"
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

# Postgres only in production (Render)
group :production do
  gem "pg"
end
