require "rails_helper"

describe "As a user" do
  describe "when I visit my profile" do
    it "can delete an address" do
      visit root_path

      click_link 'Register'

      expect(current_path).to eq(registration_path)

      fill_in 'Name', with: 'Cliff Hanger'
      fill_in 'Address', with: '456 Mountain St'
      fill_in 'City', with: 'Aspen'
      fill_in 'State', with: 'CO'
      fill_in 'Zip', with: '80218'
      fill_in 'Email', with: 'aspenperson@email.com'
      fill_in 'Password', with: 'securepassword'
      fill_in 'Password confirmation', with: 'securepassword'
      click_button 'Register'

      visit '/profile'

      click_link 'Add An Address'

      fill_in :address, with: '567 Stately Ave'
      fill_in :city, with: 'Chicago'
      fill_in :state, with: 'IL'
      fill_in :zip, with: '99999'
      fill_in :nickname, with: 'Apartment'
      click_button 'Create Address'

      expect(current_path).to eq('/profile')

      address_2 = Address.all.last

      within "#address-#{address_2.id}" do
        expect(page).to have_content('567 Stately Ave')
        expect(page).to have_content('Chicago')
        expect(page).to have_content('IL')
        expect(page).to have_content('99999')
        expect(page).to have_content('Address Name: Apartment')
        expect(page).to have_link('Edit Address')
        click_link('Delete Address')
      end

      expect(current_path).to eq('/profile')
      expect(page).to_not have_content('567 Stately Ave')
      expect(page).to_not have_content('Chicago')
      expect(page).to_not have_content('IL')
      expect(page).to_not have_content('99999')
      expect(page).to_not have_content('Address Name: Apartment')
    end
  end
end

describe "As a user" do
  describe "when I am on my profile page" do
    it "cannot delete addresses with shipped orders" do
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @brian.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )

      @user = User.create!(name: 'Cliff Hanger', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'cliff@example.com', password: 'securepassword')
      @address = @user.addresses.create!(address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)

      @order_1 = @user.orders.create!(status: 'shipped', address_id: @address.id)
      @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: true)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit '/profile'

      within "#address-#{@address.id}" do
        expect(page).to have_content(@address.nickname)
        expect(page).to_not have_link('Delete Address')
      end

      click_link 'My Orders'

      expect(page).to have_link(@order_1.id)
      expect(page).to have_content('Status: shipped')
    end

    it "cannot checkout with all addresses deleted" do
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @brian.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )

      visit root_path

      click_link 'Register'

      expect(current_path).to eq(registration_path)

      fill_in 'Name', with: 'Cliff Hanger'
      fill_in 'Address', with: '456 Mountain St'
      fill_in 'City', with: 'Aspen'
      fill_in 'State', with: 'CO'
      fill_in 'Zip', with: '80218'
      fill_in 'Email', with: 'aspenperson@email.com'
      fill_in 'Password', with: 'securepassword'
      fill_in 'Password confirmation', with: 'securepassword'
      click_button 'Register'

      visit '/profile'

      address = Address.last

      within "#address-#{address.id}" do
        click_link 'Delete Address'
      end

      visit item_path(@ogre)
      click_button 'Add to Cart'

      visit '/cart'

      click_button "Check Out"

      expect(current_path).to eq("/profile/addresses/new")
      expect(page).to have_content('You must add an address to checkout!')
    end
  end
end

describe "As a user" do
  describe "when I am on my profile page" do
    it "sees an error when deleting an addresses with orders" do
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @brian.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )

      @user = User.create!(name: 'Cliff Hanger', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'cliff@example.com', password: 'securepassword')
      @address = @user.addresses.create!(address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)

      @order_1 = @user.orders.create!(status: 'pending', address_id: @address.id)
      @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit '/profile'

      within "#address-#{@address.id}" do
        expect(page).to have_content(@address.nickname)
        click_link('Delete Address')
      end

      expect(current_path).to eq('/profile')
      expect(page).to have_content("You have an order going to that address and cannot delete it. Change the destination first.")
    end
  end
end