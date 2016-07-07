class SalesReporter
  def self.run(t = Time.now)
    # (return unless it's right after midnight)

    # Which restaurants are in the home taxon?
    restaurants = []
    Spree::Taxon.homepage.products.each {|pr| restaurants |= pr.taxons.restaurants}
    # For each of these, send a sales report
    restaurants.each do |restaurant|
      Rails.logger.info("Sending daily report to #{restaurant.name}")
      Spree::RestaurantMailer.daily_sales_report_email(restaurant, t).deliver_later
    end
  end
end
