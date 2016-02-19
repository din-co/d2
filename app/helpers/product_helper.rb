module ProductHelper
  def add_to_cart_button(product, options={})
    options = options.reverse_merge(button_class: nil, disabled: false, display_price: true, display_servings: true)
    label = options[:display_servings] ? "#{Spree.t(:add_dish)} (#{Spree.t(:two_servings)})" : Spree.t(:add_dish)
    button_class = ("btn btn-primary #{options[:button_class]}").strip
    if KITCHEN.open?
      if !product.master.can_supply?
        label = Spree.t(:sold_out)
        options[:disabled] = true
      end
    else
      if product.on_home_page?
        label = Spree.t(:next_available, date: KITCHEN.next_opens.to_s(:ordinal_weekday_month_day_short))
      else
        label = Spree.t(:not_currently_available)
        options[:display_price] = false
      end
      options[:disabled] = true
    end

    button_tag type: :submit, class: button_class, disabled: options[:disabled] do
      concat label
      if options[:display_price]
        concat ' '
        concat content_tag :span, display_price(product), class: 'list-button', itemprop: 'price'
      end
    end
  end
end
