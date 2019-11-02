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

      fill_in 'Address', with: '456 Mountain St'
      fill_in 'City', with: 'Aspen'
      fill_in 'State', with: 'CO'
      fill_in 'Zip', with: '80218'
      fill_in 'Nickname', with: 'Mountain House'
      click_button 'Add Address'

      expect(current_path).to eq('/profile')

      address = user.addresses.last

      within "address-#{address.id}" do
        expect(page).to have_content("Address Name: Mountain House")
        expect(page).to have_content("456 Mountain St")
        expect(page).to have_content("Aspen")
        expect(page).to have_content("CO")
        expect(page).to have_content("80218")
      end

    end
  end
end