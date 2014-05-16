class CombineItemsInCart < ActiveRecord::Migration
  def change
  end

  def up
    # replace multiple items in cart with one + quantity
    Cart.all.each do |cart|
      #count repeated items
      sums = cart.line_items.group(:product_id).sum(:quantity)

      sums.each do |product_id, quantity|
        if quantity > 1
          #remove items
          cart.line_items.where(product_d: product_id).delete_all

          # replace with single line
          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end
end
