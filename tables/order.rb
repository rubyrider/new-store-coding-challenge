class Order
  include StorageSupport
  
  def reload_line_items!
    @line_items = LineItem.where(order_uuid: uuid)
  end
  
  def line_items
    @line_items ||= LineItem.where(order_uuid: uuid)
  end
  
  def update_shipment(sku, tracking_number)
    line_items.find(sku: sku, tracking_number: nil)&.update(tracking_number: tracking_number)
  end
end
