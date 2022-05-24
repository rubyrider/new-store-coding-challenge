# frozen_string_literal: true

# A representational layer for Order
#   table in ORM mode, supports .create, #update, .find, .where
#   Just like another simple orm without using any original ORM
class Order
  include StorageSupport

  def reload_line_items!
    @line_items = LineItem.where(order_uuid: uuid)
  end

  def line_items
    @line_items ||= LineItem.where(order_uuid: uuid)
  end

  def update_shipment(sku, tracking_number)
    line_items.find(sku:, tracking_number: nil)&.update(tracking_number:)
  end
end
