require 'rails_helper'

RSpec.feature "Visitor clicks the 'Add to Cart' button for a product on the home page and Cart text on the button increases by one", type: :feature, js: true do
  before :each do
    @category = Category.create! name: 'Apparel'

    10.times do |n|
      @category.products.create!(
        name:  Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end

  scenario "They add an item to the cart and see the cart number updated" do

    visit root_path
    expect(page).to have_content 'My Cart (0)'
    
    first('.product').click_button('Add')
    expect(page).to have_content 'My Cart (1)'

    save_screenshot
  end
end