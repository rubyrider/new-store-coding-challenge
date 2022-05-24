require 'rubygems'
require 'bundler'
require 'securerandom'

Bundler.require

autoload :StorageSupport, "./supports/storage_support"
autoload :Product, "./tables/product"
autoload :Shipment, "./tables/shipment"
autoload :LineItem, "./tables/line_item"
autoload :Order, "./tables/order"

autoload :OrderManager, "./order_manager"
