### Coding Challenge for New Store

#### How to Setup and Play 
Very Simple, Bundler, Rspec and bin/console to play interactively

##### 

To install bundler

```bash
bundle install
```

To Run Test Suits
```bash
bundle exec rspec
```

So the available specs coverages are:
```bash
OrderManager
  basics
    should allow to add product to cart
    without line items
      should not allow to dispatch line item by tracking number
  #add_to_cart
    is expected to add line_item to cart
    is expected to increment quantity for the same line product
  #dispatch
    when line-items not shipped
      will allow to assign tracking url for shipment
      dispatches tracker "Tracker A" to line-item "SKU1"
      dispatches tracker "Tracker A" to line-item "SKU2"
      dispatches tracker "Tracker B" to line-item "SKU3"
    when line-items shipped
      will not allow to re-assign a tracking url

StorageSupport
  #update
    with valid column
      is expected to update table column with updated_at timestamp
    with invalid column
      is expected to raise concern/exceptio
```

To Enter interactive bash
```bash
bin/console
```

How to Play

```ruby
manager = OrderManager.new
# => #<OrderManager:0x0000000107182970 @errors=[], @order=#<Order:0x00000001071788d0 @updated_at=2022-05-24 07:17:54.620059 +0200, @uuid="3859d33418548421c6e93e0686c84e0c">>
manager.may_add_to_cart?
# => true
manager.may_dispatch? # Because there are no line_items
```

#### The Challenge

NewStore Coding Challenge Problem Statement
An online order contains line items. Each line item is identified by a product SKU and its quantity.
E.g. Order-1 has products SKU1, SKU1, SKU2 (repeating SKUs means same products in more than one quantity in an order). The line items would be:
- SKU1, quantity 2
- SKU2, quantity 1
  Products inside an order can be shipped in more than one shipment. A shipment is uniquely identified with a tracking number.
  E.g. Order-1 with the above SKUs could be shipped in two shipments: - Shipment with tracking tracking-1 ships SKU1, SKU2
- Shipment with tracking tracking-2 ships SKU1
  Updates for a Shipment can arrive in multiple parts. For example:
  \# `update 1` at timestamp-1
- Order-1 got SKU1 shipped with tracking-1
  \# `update 2` at timestamp-2
- Order-1 got SKU1 shipped with tracking-2
  \# `update 3` at timestamp-3
- Order-1 got SKU2 shipped with tracking-1
  One shipment update contains all or part of SKUs for one tracking code. (i.e assume one tracking per shipment update)
  After the above three updates, all SKUs in Order-1 have shipment information. These will be the shipments for Order-1:
- Shipment with tracking-1 shipped SKU1, SKU2
- Shipment with tracking-2 shipped SKU1
  Shipment information can be repeated in a later update. For example, consider this alternative version of update 3:
  \# `update 3, alternative 1` at timestamp-3 - Order-1 got SKU1 shipped with tracking-1 - Order-1 got SKU2 shipped with tracking-1
  After `update 2` only one quantity of SKU2 needs an update, whereas the update provides for SKU1 also. When such a shipment update comes with shipment information for more SKUs than there is room for to update, such updates should not be applied.
  Therefore following alternatives cannot be accepted either:
  \# `update 3 alternative2` at timestamp-3 - Order-1 got SKU1 shipped with tracking-2
- There are no SKU1s left that need shipment update - Order-1 got SKU2 shipped with tracking-2
- This part is valid, but since the update itself has an invalid part, the update needs to be rejected
  \# `update 3 alternative 3` at timestamp-3 - Order-1 got SKU3 shipped with tracking-1
- There is no such SKU 'SKU3' in the original order, so this update is invalid.
  Programming Task
  Write a service that allows the following operations:
- add an order with line items
- accept shipment updates for an order
- follow the rules for rejecting updates as specified above - return current known shipments for an order
- write unit tests covering all update scenarios described above to verify the solution meets the requirement
  Assume no interaction with network or database for the solution. A solution that keeps everything in memory is sufficient. All the above operations should be runnable and testable.
