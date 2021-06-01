require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do

    before do
      @category = Category.new(:name => "Test")
      @product = @category.products.new(:name => "Test", :price => 65535, :quantity => 2000000)
    end

    # validation tests/examples here
    it "successfully saves a product" do
      @product.save
      expect(@product).to be_valid
      expect(@product.errors.full_messages).to be_empty
    end

    # validates :name, presence: true
    it "fails to save if name is not given" do
      @nonameproduct = Product.new(:category_id => 1, :price => 65535, :quantity => 2000000)
      @nonameproduct.save
      expect(@nonameproduct).not_to be_valid 
    end

    # validates :price, presence: true
    it "fails to save if price is not given" do
      @nopriceproduct = Product.new(:category_id => 1, :name => "Test", :quantity => 2000000)
      @nopriceproduct.save
      expect(@nopriceproduct).not_to be_valid 
    end

    # validates :quantity, presence: true
    it "fails to save if quantity is not given" do
      @noquantityproduct = Product.new(:category_id => 1, :name => "Test", :price => 65535)
      @noquantityproduct.save
      expect(@noquantityproduct).not_to be_valid 
    end

    # validates :category, presence: true
    it "fails to save if category is not given" do
      @nocategoryproduct = Product.new(:name => "Test", :price => 65535, :quantity => 2000000)
      @nocategoryproduct.save
      expect(@nocategoryproduct).not_to be_valid 
    end
  end
end