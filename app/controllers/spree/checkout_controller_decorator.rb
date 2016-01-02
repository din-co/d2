Spree::CheckoutController.class_eval do
  before_filter :add_delivery_window_id_to_shipment_attributes, only: :update

  def add_delivery_window_id_to_shipment_attributes
    return if Spree::PermittedAttributes.shipment_attributes.include?(:delivery_window_id)
    Spree::PermittedAttributes.shipment_attributes << :delivery_window_id
  end
end