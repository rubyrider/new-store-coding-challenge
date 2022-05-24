require 'aasm'
require 'byebug'

class OrderManager
  include AASM
  
  ShipmentCompleted = StandardError.new
  
  attr_reader :order, :errors
  
  def initialize
    @order  = Order.create
    @errors = []
  end
  
  def valid?
    @errors.count < 1
  end
  
  aasm do
    state :empty_cart, initial: true
    state :adding_to_cart
    state :dispatching
    state :dispatched
    
    event :add_to_cart, after: :add_product_to_cart! do
      transitions from: %i[empty_cart adding_to_cart], to: :adding_to_cart
    end
    
    event :dispatch, guard: :ready_for_dispatch? do
      transitions from: %i[adding_to_cart dispatching],
                  to: :dispatching,
                  after: :dispatch_product!
    end
    
    event :shipment_done do
      transitions from: :dispatching, to: :dispatched, guard: :shipment_completed?
    end
  end
  
  alias_method :status, :aasm_read_state
  
  private
    
    def add_product_to_cart!(sku, quantity)
      if (line_item = line_items.find(sku: sku))
        line_item.quantity += quantity
      else
        LineItem.create(order_uuid: order.uuid, sku: sku, quantity: quantity)
      end
      
      self
    end
    
    def dispatch_product!(sku, tracking_number)
      # Lets keep a shipment record in the db/memory for
      Shipment.find(tracking_number: tracking_number) || Shipment.create(tracking_number: tracking_number)
      
      line_items.find(sku: sku)&.update(tracking_number: tracking_number)
      
      shipment_done! if may_shipment_done?
      
      self
    end
    
    def line_items
      order.reload_line_items!
    end
    
    def line_items_with_out_shipment
      line_items.find(tracking_number: nil)
    end
    
    def ready_for_dispatch?(sku = nil, *)
      return still_shipment_required? unless sku
      
      line_items.find(sku: sku)&.tracking_number.nil?
    end
    
    def still_shipment_required?
      (line_items.count > 0 && !shipment_completed?) unless sku
    end
    
    def shipment_completed?
      Array(line_items_with_out_shipment).count == 0
    end
end
