class CombineItemsInCart < ActiveRecord::Migration

  def up
    # replace multiple items in cart with one + quantity
    Cart.all.each do |cart|
      #count repeated items
      sums = cart.line_items.group(:product_id).sum(:quantity)
      sums.each do |product_id, quantity|
        if quantity > 1
          #remove items
          cart.line_items.where(product_id: product_id).delete_all

          # replace with single line
          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end

  def down
# split items with quantity>1 into multiple items
    LineItem.where("quantity>1").each do |line_item|
# add individual items
      line_item.quantity.times do
        LineItem.create cart_id: line_item.cart_id,
                        product_id: line_item.product_id, quantity: 1
      end
# remove original item
      line_item.destroy
    end
  end
end
