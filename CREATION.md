# Steps taken to create this app

(See (#tools)[Tools] below if you don't have a fancy Rails setup already.)

- Repo created on Github with `README.md` and `.gitignore` for Rails
- Followed most instructions at https://gorails.com/setup/osx/10.11-el-capitan
    - Installed Ruby 2.2.3
    - Installed Rails 4.2.5
- Created the Rails app
    - Created the dev and test databases `rake db:create`
- Declared gem dependencies for Solidus https://github.com/solidusio/solidus#getting-started
    - `gem 'solidus'`
    - `gem 'solidus_auth_devise'`
- Installed the gems with `bundle`
- Generated the config files and migrations
    - `rails generate spree:install`
    - `rake railties:install:migrations`
    - `rake generate devise:install`
- Applied the migrations `rake db:migrate`

### Tools

- Installed `rbenv`, `ruby-build`, and `postgresql` using `brew`
