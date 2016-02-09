module Spree
  module ProductsHelper
    # @return [String] a cache invalidation key for products
    def cache_key_for_products
      count = @products.count
      max_updated_at = (@products.maximum(:updated_at) || Date.today).to_s(:number)
      "#{I18n.locale}/#{current_currency}/spree/products/all-#{params[:page]}-#{max_updated_at}-#{count}-#{KITCHEN.status}"
    end
  end
end
