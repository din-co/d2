module Spree
  class RestaurantMailer < BaseMailer
    def daily_sales_report_email(restaurant_taxon, shipment_date)
      recipients = PartnerContact.where(taxon: restaurant_taxon).pluck(:email)
      ops = Rails.configuration.x.ops_email_address
      @shipment_date = shipment_date
      @pickup = Hash.new { |hash, key| hash[key] = 0 }
      grand_total = 0
      Order.shippable_day_of(shipment_date).each do |order|
        order.line_items.each do |line_item|
          @pickup[line_item.variant.product.name] += line_item.quantity
          grand_total += line_item.quantity
        end
      end
      @pickup["Grand Total"] = grand_total

      subj = "Din - Pickup #{shipment_date.strftime('%Y-%m-%d')}: #{grand_total} items"

      mail(to: recipients, from: ops, bcc: ops, subject: subj)
    end
  end
end

class PartnerContact < ActiveRecord::Base
  belongs_to :taxon
  validate :email, presence: true
end
