class Shipment
  include StorageSupport
  
  attr_accessor :tracking_number, :line_items, :state
  
  def initialize(*)
    super
    @tracking_number = SecureRandom.hex
    @state           = 'OrderReceived'
  end
end
