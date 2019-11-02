require 'rails_helper'

RSpec.describe "As a user" do
  describe "on my user profile page" do

    before :each do
      @user = User.create!(name: 'Cliff Hanger', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'cliff@example.com', password: 'securepassword')
      @address = @user.addresses.create!(address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    end

    it "can make a new address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit '/profile'

      click_link 'Add An Address'

      expect(current_path).to eq('/profile/addresses/new')

      fill_in :address, with: '1670 Merelo Ave'
      fill_in :city, with: 'Martinez'
      fill_in :state, with: 'CA'
      fill_in :zip, with: '94553'
      fill_in :nickname, with: 'California House'
      click_button 'Create Address'

      expect(current_path).to eq('/profile')

      address_1 = @user.addresses.first

      within "#address-#{address_1.id}" do
        expect(page).to have_content("Address Name: Home")
        expect(page).to have_content("123 Main St")
        expect(page).to have_content("Denver")
        expect(page).to have_content("CO")
        expect(page).to have_content("80218")
      end

      address_2 = @user.addresses.last

      within "#address-#{address_2.id}" do
        expect(page).to have_content("Address Name: California House")
        expect(page).to have_content("1670 Merelo Ave")
        expect(page).to have_content("Martinez")
        expect(page).to have_content("CA")
        expect(page).to have_content("94553")
      end

    end

    it "sees an error message when a new address form isn't filled out correctly" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit '/profile/addresses/new'

      fill_in :address, with: ''
      fill_in :city, with: 'Martinez'
      fill_in :state, with: 'CA'
      fill_in :zip, with: '94553'
      fill_in :nickname, with: 'California House'
      click_button 'Create Address'

      expect(page).to have_content("Address can't be blank")

      fill_in :address, with: '1670 Merelo Ave'
      fill_in :city, with: 'Martinez'
      fill_in :state, with: 'CA'
      fill_in :zip, with: '94553'
      fill_in :nickname, with: 'California House'
      click_button 'Create Address'

      expect(current_path).to eq('/profile')
    end

    it "shows an error message if that address is already taken" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit '/profile/addresses/new'

      fill_in :address, with: '1670 Merelo Ave'
      fill_in :city, with: 'Martinez'
      fill_in :state, with: 'CA'
      fill_in :zip, with: '94553'
      fill_in :nickname, with: 'Home'
      click_button 'Create Address'

      expect(page).to have_content("Nickname has already been taken")
    end
  end
end

RSpec.describe "as an Admin or Merchant" do
  it "cannot see a link to make a new address" do
    admin = User.create!(name: 'Admin', address: '90210 Beverly Hills Blvd', city: 'Beverly Hills', state: 'CA', zip: 80999, email: 'admin@admin.com', password: 'securepassword', role: 2)
    merchant = User.create!(name: 'Merchant', address: '1111 Shop Rd', city: 'Chicago', state: 'IL', zip: 88888, email: 'merchant@merchant.com', password: 'securepassword', role: 1)

    upper_level_users = [admin, merchant]

    upper_level_users.each do |admin_or_merchant|
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_or_merchant)

      visit '/profile'

      expect(page).to_not have_link("Add An Address")
    end
  end
  it "cannot visit the page to make a new address" do
    admin = User.create!(name: 'Admin', address: '90210 Beverly Hills Blvd', city: 'Beverly Hills', state: 'CA', zip: 80999, email: 'admin@admin.com', password: 'securepassword', role: 2)
    merchant = User.create!(name: 'Merchant', address: '1111 Shop Rd', city: 'Chicago', state: 'IL', zip: 88888, email: 'merchant@merchant.com', password: 'securepassword', role: 1)

    upper_level_users = [admin, merchant]

    upper_level_users.each do |admin_or_merchant|
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_or_merchant)

      visit '/profile/addresses/new'

      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end