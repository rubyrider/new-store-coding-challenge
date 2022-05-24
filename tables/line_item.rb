# frozen_string_literal: true

# A representational layer for LineItem
#   table in ORM mode, supports .create, #update, .find, .where
#   Just like another simple orm without using any original ORM
class LineItem
  include StorageSupport

  attr_accessor :uuid, :sku, :tracking_number, :quantity, :order_uuid

  def initialize(params = {})
    super(params)
    @state      = 'Initialized'
    @sku        = params[:sku]
    @order_uuid = params[:order_uuid]
    @quantity   = params[:quantity] || 1
  end

  def order
    @order ||= Order.find(uuid: order_uuid)
  end

  def product
    @product ||= Product.find(sku:)
  end

  def shipment
    @shipment ||= Shipment.find(tracking_number:)
  end
end
