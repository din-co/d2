# d2
Solidus-based commerce application


## How to Override Templates (FAQ)

- Where are the templates to copy?

`bundle show solidus_frontend`

- Where do I copy them to?

Into your local copy, under `app/views/...` in the same place as they are in the `solidus_frontend` gem, _e.g._:

``` console
$ mkdir -p app/views/spree/home
$ cp $(bundle show solidus_frontend)/app/views/spree/home/index.html.erb app/views/spree/home
```
