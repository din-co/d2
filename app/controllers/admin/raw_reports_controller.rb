require 'csv'
class Admin::RawReportsController < Spree::Admin::BaseController

  def outbound_shipments
    orders = Spree::Order.shippable_day_of(date)
    orders.includes(:ship_address, :line_items, shipments: :selected_delivery_window)
    csv_string = CSV.generate do |csv|
      csv << Spree::Order.csv_headers
      orders.map { |order| order.to_csv_data }
    end
    render text: csv_string
  end

  private
  def date
    if params[:date].present?
      Time.zone.parse(params[:date])
    else
      Time.current
    end
  end
end
