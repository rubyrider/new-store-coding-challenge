# frozen_string_literal: true

# A representational layer for Product
#   table in ORM mode, supports .create, #update, .find, .where
#   Just like another simple orm without using any original ORM
class Product
  include StorageSupport

  attr_accessor :sku

  def initialize(params = {})
    super(params)

    @sku = SecureRandom.hex(3)
  end
end
