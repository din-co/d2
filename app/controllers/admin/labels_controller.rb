class Admin::LabelsController < Spree::Admin::BaseController
  layout "admin/labels"

  def tote
    @title = "Tote Labels"
    @orders = Spree::Order
      .shippable_day_of(date)
      .includes(:ship_address, :line_items, {shipments: :selected_delivery_window})
  end

  def meal
    @title = "Meal Bag Labels"
    @products = Spree::Product.all
  end

  def ingredient
    @title = "Ingredient Labels"
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
