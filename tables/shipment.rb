# frozen_string_literal: true

# A representational layer for Shipment with tracking url
#   table in ORM mode, supports .create, #update, .find, .where
#   Just like another simple orm without using any original ORM
class Shipment
  include StorageSupport

  attr_accessor :tracking_number, :line_items, :state

  def initialize(*)
    super
    @tracking_number = SecureRandom.hex
    @state           = 'OrderReceived'
  end
end
