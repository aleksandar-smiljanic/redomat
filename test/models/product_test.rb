require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "My Book Title",
                          description: "yyy",
                          image_url: "zzz.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
                 product.errors[:price]
    product.price = 1
    assert product.valid?
  end

  def new_product (image_url)
    Product.new(title: "My Book 12345",
                description: "yyy",
                price: 1,
                image_url: image_url
                )
  end

  test "image url" do
    ok = %w{sax.gif sax.jpg sax.png sax.Jpg https://x.y.z/a/b/c/d/sax.gif}
    nok = %w{sax.doc sax.xls sax.pdf}

    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end

    nok.each do |name|
      assert new_product(name).invalid?, "#{name} should not be valid"
    end

  end

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "yyy",
                          price: 1,
                          image_url: "sax.gif")
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title], "saxsax"
  end
end
