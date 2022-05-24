class Product
  include StorageSupport
  
  attr_accessor :sku
  
  def initialize(params = {})
    super(params)
    
    @sku = SecureRandom.hex(3)
  end
end
