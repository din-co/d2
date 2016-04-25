class Admin::LabelsController < Spree::Admin::BaseController
  layout "admin/labels"
  helper_method :date

  before_action :require_quantity, only: :ingredient_print

  def tote
    @title = "Tote Labels"
    @delivery_windows = Spree::DeliveryWindow.includes(:shipping_method)
    @order_counts = {}
    @label_counts = @delivery_windows.each_with_object({}) do |window, counts|
      orders = window.orders.shippable_day_of(date).select(:id).to_a
      counts[window.id] = orders.sum(&:tote_tags_count)
      @order_counts[window.id] = orders.size
    end
  end

  def tote_print
    orders = Spree::Order.including_tote_data.shippable_day_of(date)
    orders = orders.where(spree_shipments: {delivery_window_id: delivery_window_id}) if delivery_window_id
    @labels = orders.flat_map(&:tote_tags)
  end

  def meal
    @title = "Meal Bag Labels"
    @products = Spree::Product.all
  end

  def meal_print
    @product = Spree::Product.friendly.find(params[:id])
  end

  def ingredient
    @title = "Ingredient Labels"
    @large_labels = large_labels
    @small_labels = small_labels
  end

  def ingredient_print
    @quantity = quantity
    @label_size = label_size
    case @label_size
    when "small"
      @sheet_count = 9 * 7 # 63 per sheet
      @sheet_class = "ol1025tc-sheet"
      @label_class = "ingredient-label--small"
      labels = small_labels
    when "large"
      @sheet_count = 4 * 3 # 12 per sheet
      @sheet_class = "ol350tc-sheet"
      @label_class = "ingredient-label--large"
      labels = large_labels
    end
    @labels = labels.lines.flat_map{ |s| [s.strip] * @quantity }
  end

  private
  def date
    if params[:date].present?
      Time.zone.parse(params[:date]).to_date
    else
      Time.current.to_date
    end
  end

  def delivery_window_id
    params[:delivery_window_id].presence
  end

  def large_labels
    params[:large_labels].presence || ""
  end

  def small_labels
    params[:small_labels].presence || ""
  end

  def quantity
    params[:quantity].to_i
  end

  def label_size
    params[:label_size].presence
  end

  def require_quantity
      if quantity > 0
        return if large_labels.present? && label_size == "large"
        return if small_labels.present? && label_size == "small"
      end
      flash[:error] = "Quantity and some #{label_size} are required."
      redirect_to admin_labels_ingredient_url(params.except(:controller, :action))
  end
end
