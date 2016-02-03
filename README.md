# d2
Solidus-based commerce application.

## Note: forcing the kitchen open or closed
Set the environment variable `KITCHEN_STATUS` to either `open` or `closed` to force that behavior, regardless of the automatic timer. The kitchen will stay in the overridden state until the `KITCHEN_STATUS` variable is unset.

Heroku Dashboard:
- Visit the app's settings page (e.g. for staging https://dashboard.heroku.com/apps/d2-staging/settings)
- Click "Reveal Config Vars". **Use caution when editing these important variables.**
- Force open: set or create a `KITCHEN_STATUS` variable to `open`
- Force closed: set or create a `KITCHEN_STATUS` variable to `closed`
- Reset to automatic timer: delete the `KITCHEN_STATUS` variable

Command line:
- Force open: `heroku config:set KITCHEN_STATUS=open -a din-marketplace`
- Force closed: `heroku config:set KITCHEN_STATUS=closed -a din-marketplace`
- Reset to automatic timer `heroku config:unset KITCHEN_STATUS -a din-marketplace`

### Development server:
Your choice: `heroku local --port 3000 --procfile Procfile.dev` to see the website at http://localhost:3000 (which also launches `mailcatcher` on http://localhost:3100) or if you can't be bothered, `rails server` will run just the website.

**N.B.:** There is a canonical redirect to `local.flavvor.co` in development mode. You may add an entry to your `/etc/hosts` file for `local.flavvor.co 127.0.0.1` if you need to access the development site without internet access.

#### Seeing email in development:
`gem install mailcatcher -- --with-cppflags=-I/usr/local/opt/openssl/include`  (flags necessary on OS X El Capitan) and then run `mailcatcher` from the command line.

## Syncing production data to staging (notes for posterity)
- Back up staging: `heroku pg:backups capture -r staging`
- Copy production to staging: `heroku pg:copy din-marketplace::HEROKU_POSTGRESQL_CYAN_URL HEROKU_POSTGRESQL_NAVY_URL -r staging`
- Sync missing image attachments: `aws s3 sync --acl public-read --storage-class REDUCED_REDUNDANCY s3://din-shop-img/spree/ s3://din-shop-img/staging/spree/`

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
    $ INCLUDE_SAMPLES=true bin/rake db:create db:schema:load db:seed
    ```

    Omit sample restaurants, chefs, and meals by removing `INCLUDE_SAMPLES=true`.

    Reset your DB to the starting state with `bin/rake db:reset`.

    **Note:** This does not create the two `StoreCreditType`s or default `ReimbursementType` from migrations: `20150506181611_create_spree_store_credit_payment_method.rb` and the next two in sequence. That's OK.

2. Create sample products:

    Product Name and price are required. Description is optional.

    You must have restaurant and chef taxons for this to work. If you used `INCLUDE_SAMPLES=true` above, then you will have sample restaurant and chef taxons.

    ```console
    $ bin/rails r 'CreateProduct.create!("Your Product Name", 30, "Description.")'
    ```

3. Start server (also starts mailcatcher).

    ```console
    $ heroku local --port 3000 --procfile Procfile.dev
    ```

4. [Login to the Admin](http://localhost:3000/admin) using `admin@din.co`/`password` (only created in development)

5. Add new dishes!

## Rebuild images

```
bundle exec rake paperclip:refresh:thumbnails CLASS=Spree::Image
bundle exec rake paperclip:refresh:thumbnails CLASS=Spree::Taxon
```

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
