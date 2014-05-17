require 'test_helper'

class CartTest < ActiveSupport::TestCase
  fixtures :products, :carts
  # test "the truth" do
  #   assert true
  # end
  test "add unique products" do
    cart = Cart.create
    ruby_book = products(:ruby)
    book_one = products(:one)
    cart.add_product(ruby_book.id).save!
    cart.add_product(book_one.id).save!
    assert_equal 2, cart.line_items.size
    assert_equal book_one.price + ruby_book.price, cart.total_price
  end

  test "add duplicate product" do
    cart = Cart.create
    ruby_book = products(:ruby)
    cart.add_product(ruby_book.id).save!
    cart.add_product(ruby_book.id).save!
    assert_equal 2*ruby_book.price, cart.total_price
    assert_equal 1, cart.line_items.size
    assert_equal 2, cart.line_items[0].quantity
  end
end
