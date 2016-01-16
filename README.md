# d2
Solidus-based commerce application

### Development server:
Your choice: `heroku local --port 3000 --procfile Procfile.dev` to see the website at http://localhost:3000 (which also launches `mailcatcher` on http://localhost:3100) or if you can't be bothered, `rails server` will run just the website.

#### Seeing email in development:
`gem install mailcatcher -- --with-cppflags=-I/usr/local/opt/openssl/include`  (flags necessary on OS X El Capitan) and then run `mailcatcher` from the command line.

## How to Override Templates (FAQ)

- Where are the templates to copy?

    ```console
    $ bundle show solidus_frontend
    ```

- Where do I copy them to?

    Into your local copy, under `app/views/...` in the same place as they are in the `solidus_frontend` gem, _e.g._:

    ``` console
    $ mkdir -p app/views/spree/home
    $ cp $(bundle show solidus_frontend)/app/views/spree/home/index.html.erb app/views/spree/home
    ```


## Dev Env Setup

1. Create and seed the database

    ```console
    $ git pull
    $ bundle
    $ bin/rake db:create db:schema:load db:seed
    ```

    Reset your DB to the starting state with `bin/rake db:reset`.

    **Note:** This does not create the two `StoreCreditType`s or default `ReimbursementType` from migrations: `20150506181611_create_spree_store_credit_payment_method.rb` and the next two in sequence. That's OK.

2. Start server (also starts mailcatcher).

    ```console
    $ heroku local --port 3000 --procfile Procfile.dev
    ```

3. [Login to the Admin](http://localhost:3000/admin) using `admin@din.co`/`password` (only created in development)

4. Add new dishes!


## Editorial Guidelines

View the [Admin Editorial Guide](https://docs.google.com/document/d/1HXd1ObkDjGsxLjm6wnhntjjaQn0TC2H3dtyownfo41w/edit) to learn to:

* Add new dishes
* Edit taxons
* etc


## Dev Template Editing

Templates for editing can be found by viewing these bundles:

```
bundle show solidus_core
bundle show solidus
bundle show solidus_frontend
```

## SSL Setup

Most infrastructure setup steps are described here: https://devcenter.heroku.com/articles/ssl-endpoint

Key, CSR, and cert are stored in a 1Password vault.
