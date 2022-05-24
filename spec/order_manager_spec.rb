require 'spec_helper'

RSpec.describe OrderManager do
  let(:manager) { described_class.new }
  
  let(:product_sku1) { Product.create(sku: 'SKU1') }
  let(:product_sku2) { Product.create(sku: 'SKU2') }
  let(:product_sku3) { Product.create(sku: 'SKU3') }
  
  context "basics" do
    it 'should allow to add product to cart' do
      expect(manager).to be_may_add_to_cart
    end
    
    context 'without line items' do
      it 'should not allow to dispatch line item by tracking number' do
        expect(manager).not_to be_may_dispatch
      end
    end
  end
  
  describe '#add_to_cart' do
    it 'is expected to add line_item to cart' do
      expect { manager.add_to_cart('SKU1', 1) }.to change(LineItem, :count).by(1)
    end
    
    it 'is expected to increment quantity for the same line product' do
      manager.add_to_cart('SKU1', 1)
      expect { manager.add_to_cart('SKU1', 3) }.to change(LineItem, :count).by(0)
      expect { manager.add_to_cart('SKU2', 4) }.to change(LineItem, :count).by(1)
    end
  end
  
  describe '#dispatch' do
    before do
      manager.add_to_cart('SKU1', 1)
      manager.add_to_cart('SKU2', 3)
      manager.add_to_cart('SKU3', 10)
    end
    
    context 'when line-items not shipped' do
      it 'will allow to assign tracking url for shipment' do
        expect(manager).to be_may_dispatch('SKU1', 'Tracking A')
        expect(manager).to be_may_dispatch('SKU2', 'Tracking B')
        expect(manager).to be_may_dispatch('SKU3', 'Tracking A')
      end
      
      it 'dispatches tracker "Tracker A" to line-item "SKU1"' do
        expect(manager).to receive(:dispatch_product!).with('SKU1', 'Tracking A')
        
        manager.dispatch!('SKU1', 'Tracking A')
      end
      
      it 'dispatches tracker "Tracker A" to line-item "SKU2"' do
        expect(manager).to receive(:dispatch_product!).with('SKU2', 'Tracking A')
        
        manager.dispatch!('SKU2', 'Tracking A')
      end
      
      it 'dispatches tracker "Tracker B" to line-item "SKU3"' do
        expect(manager).to receive(:dispatch_product!).with('SKU3', 'Tracking B')
        
        manager.dispatch!('SKU3', 'Tracking B')
      end
    end
    context 'when line-items shipped' do
      it 'will not allow to re-assign a tracking url' do
        manager.dispatch!('SKU1', 'Tracking A')
        
        expect(manager).not_to be_may_dispatch('SKU1', 'Tracking A')
      end
    end
  end
end
