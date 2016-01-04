# d2
Solidus-based commerce application

### Development server:
Your choice: `heroku local --port 3000 --procfile Procfile.dev` to see the website at http://localhost:3000 (which also launches `mailcatcher` on http://localhost:3100) or if you can't be bothered, `rails server` will run just the website.

#### Seeing email in development:
`gem install mailcatcher -- --with-cppflags=-I/usr/local/opt/openssl/include`  (flags necessary on OS X El Capitan) and then run `mailcatcher` from the command line.

## How to Override Templates (FAQ)

- Where are the templates to copy?

`bundle show solidus_frontend`

- Where do I copy them to?

Into your local copy, under `app/views/...` in the same place as they are in the `solidus_frontend` gem, _e.g._:

``` console
$ mkdir -p app/views/spree/home
$ cp $(bundle show solidus_frontend)/app/views/spree/home/index.html.erb app/views/spree/home
```

## Dev Env Setup

1. Setup and seed the database, and create the root user.

    You will be prompted to create an admin account.

    ```
    git pull
    bundle
    rake db:drop db:create db:migrate db:seed
    ```

2. Start server.

    ```
    bundle exec rails server
    ```

3. [Login to the Admin](http://localhost:3000/admin)

4. You may now add new dishes!


## Add a New Dish

1. Go to [Products page](http://localhost:3000/admin/products) and click "+ New Product".
2. Add product details:
    - **Name**: name of the dish.
    - **Master Price**: retail price of the dish.
    - **Shipping Categories**: select "default"
    - **Prototype**: select "Dish"
    - Click "Create"
3. Add product **description** (you may use html)
4. Choose "Product Properties"
    - **time**: The number of full minutes this recipe takes to prepare (eg. "23"). Just the whole number, Do not include a label for units.
    - **components**: The list of components which will be included in the bag.
        - Format each component in a list item (`<li>`) tag, they will be placed inside a `<ul class="dish-components">` tag.
        ```html
        <li>Hodo Soy tofu</li>
        <li>shallot</li>
        <li>vegetable stock</li>
        <li>coconut milk</li>
        ```
    - **directions**: The list of directions for preparing the dish.
        - Format each step in a list item (`<li>`) tag, they will be placed inside a `<ol class="dish-direction">` tag.
        - Use `<b>` tags to highlight components and pantry items.
        - Use `<em>` tags for chef notes.
        ```html
        <li>Place a medium saucepan over high heat and add 1 tablespoon of <b>high-heat oil</b>.</li>
        <li>Thinly slice the <b>shallot</b>. Add to the saucepan and cook until translucent.</li>
        <li>Add <b>diced pumpkin</b>. Cook for 3 minutes.</li>
        <li>
          Remove from heat. Add 3 tablespoons of <b>water</b>.
          <em>Removing from heat decreases the chance of a flare up if the oil splatters and catches fire.</em>
        </li>
        ```
    - **ingredients**: A paragraph of the full ingredient list which makes up the dish. Format as a single paragraph. You may use html tags, but tags should be limited to inline tags. Ingredients will be placed inside a `<p class="dish-ingredients">` tag.
    - **callout-1** and **callout-2**: A short paragraph used to highlight interesting things about this dish. You may use html, callout content will be placed inside a `<div class="dish-callout-1">` and `<div class="dish-callout-2">` tag.
    - **sidebar**: related content to add insight or clarification about some aspect of the dish.
        - Format using `p, ul, ol, li` and other inline tags. Content will be placed inside a `<div class="dish-sidebar">` tag.
        ```html
        <h3>title</h3>
        <p>Some <b>interesting</b> content in a paragraph.<p>
        <ul>
          <li>A bulleted unordered list of things.<li>
          <li>A bulleted unordered list of things.<li>
        </ul>
        <ol>
          <li>A numbered ordered list of steps.<li>
          <li>A numbered ordered list of steps.<li>
          <li>A numbered ordered list of steps.<li>
        </ol>
        ```
5. Add taxons:
    - **restaurant**: select *one* restaurant.
    - **chef**: select *one* chef.
    - **diets**: select all associated diets.
    - **pantry**: select all pantry items.
    - **equipment**: select all needed equipment.

    Taxons shouldn't change very often. If a taxon needs to be added, make sure there isn't and existing item before adding a new taxon.
6. Add an image:
    - Click "Images", then "+ New Image"
    - Select the file to upload.
        - **dimensions:** 1920px wide × 1080px tall at 72dpi.
        - **compression:** in Photoshop start with "Preset: JPEG High". Compress the image as low as possible until the quality of the image starts to degrade.
    - Do not add "Alternative Text", we will use the Dish Name as the "alt text".
    - Click "Update"


## Adding Taxons

1. Go to [Product Taxonomies](http://localhost:3000/admin/taxonomies).
2. Click the "Edit" link for the taxonomy you wish to add a taxon to.
3. Right-click on the parent taxon to add a child taxon.
4. Once added, right-click on the taxon you created, and click "Edit".
5. Review the **permalink** to ensure it makes sense: all lowercase, spaces replaced with dashes.
6. Add a **description** related to the taxon type. View sibling taxons for examples. You may use html to format the description.

    - **restaurants**: restaurant bio.
    - **chefs**: chef bio.
    - **diets**: add further clarification about this diet to describe what use of this tag means.
    - **equipment**: add further clarification about the equipment, substitute equipment, etc.
    - **pantry**: add further clarification about the pantry item, substitution ingredients, etc.

## Dev Template Editing

Templates for editing can be found by viewing these bundles:

```
bundle show solidus_core
bundle show solidus
bundle show solidus_frontend
```
