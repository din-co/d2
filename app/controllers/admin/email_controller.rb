class Admin::EmailController < Spree::Admin::BaseController
  include Spree::Core::ControllerHelpers::Order
  layout "admin/email"

  # prevent auto insert of New Relic js
  newrelic_ignore_enduser

  def menu
    @searcher = build_searcher(params.merge(include_images: true))
    @products = @searcher.retrieve_products
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end

  def product
    @searcher = build_searcher(params.merge(include_images: true))
    @products = @searcher.retrieve_products
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end
end
