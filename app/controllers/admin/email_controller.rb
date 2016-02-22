class Admin::EmailController < Spree::Admin::BaseController
  include Spree::Core::ControllerHelpers::Order
  layout "admin/email"

  # prevent auto insert of New Relic js
  newrelic_ignore_enduser

  def menu
    @products = Spree::Taxon.homepage.products
  end

  def product
    @products = Spree::Product.where(id: params[:id])
  end
end
