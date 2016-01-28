class Admin::LabelsController < Spree::Admin::BaseController
  layout "admin/labels"

  before_action :require_quantity, only: :ingredient_print

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
      Time.zone.parse(params[:date])
    else
      Time.current
    end
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
