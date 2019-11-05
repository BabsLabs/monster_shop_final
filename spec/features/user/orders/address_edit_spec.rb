require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Order Show Page' do
  describe 'As a Registered User' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      @user = User.create!(name: 'Tony Lemons', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan_1@example.com', password: 'securepassword')
      @home = @user.addresses.create!(address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @cottage = @user.addresses.create!(address: '456 Cottage Rd', city: 'Aspen', state: 'CO', zip: 80200, nickname: 'Cottage')
      @order_1 = @user.orders.create!(status: "packaged", address_id: @home.id)
      @order_2 = @user.orders.create!(status: "pending", address_id: @home.id)
      @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: true)
      @order_item_2 = @order_2.order_items.create!(item: @giant, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'I can edit the address of a pending order' do
      visit '/profile/orders'

      within "#order-#{@order_1.id}" do
        expect(page).to have_content("This Order Is Going To Your: Home")
        expect(page).to_not have_link("Edit Shipping Address")
      end

      within "#order-#{@order_2.id}" do
        expect(page).to have_content("This Order Is Going To Your: Home")
        click_link("Edit Shipping Address")
      end

      expect(current_path).to eq("/profile/orders/#{@order_2.id}/edit_address")

      expect(page).to have_content("Edit Your Shipping Address For Order Number #{@order_2.id}")


      select("Cottage", from: "dropdown-list").select_option
      click_button "Update Address"

      expect(current_path).to eq("/profile/orders")

      # within "#order-#{@order_2.id}" do
      #   expect(page).to have_content("This Order Is Going To Your: Cottage")
      # end
    end
  end
end
