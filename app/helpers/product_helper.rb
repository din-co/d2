module ProductHelper
  def kitchen_closed_class
    if KITCHEN.open?
      ''
    else
      'kitchen-closed'
    end
  end

  def add_to_cart_button(product, button_class=nil)
    label = Spree.t(:add_dish)
    disabled = false
    button_class = ("btn btn-primary #{button_class}").strip
    if KITCHEN.open?
      if !product.master.can_supply?
        label = Spree.t(:sold_out)
        disabled = true
      end
    else
      # TODO: I18n this label
      label = "Becomes available #{KITCHEN.next_opens.to_s(:ordinal_weekday_month_day)}"
      disabled = true
    end
    button_tag type: :submit, class: button_class, disabled: disabled do
      concat label
      content_tag :span, class: 'list-button', itemprop: 'price' do
        display_price(product)
      end
    end
  end
end
