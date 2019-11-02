require 'rails_helper'

RSpec.describe "As a user" do
  describe "on my user profile page" do

    before :each do
      @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
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
  end
end