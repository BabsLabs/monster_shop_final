require "rails_helper"

describe "As a user" do
  describe "when I visit my profile" do
    before :each do
      @user = User.create!(name: 'Cliff Hanger', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'cliff@example.com', password: 'securepassword')
      @address = @user.addresses.create!(address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    end

    it "can edit an address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit '/profile'

      within "#address-#{@address.id}" do
        click_link 'Edit Address'
      end

      expect(page).to have_content("Edit Your #{@address.nickname.capitalize} Address")

      fill_in :address, with: '567 State Ave'
      fill_in :city, with: 'Denver'
      fill_in :state, with: 'CO'
      fill_in :zip, with: '80218'
      fill_in :nickname, with: 'Home'
      click_button 'Update Address'

      expect(current_path).to eq('/profile')

      within "#address-#{@address.id}" do
        expect(page).to have_content('567 State Ave')
        expect(page).to have_content('Denver')
        expect(page).to have_content('CO')
        expect(page).to have_content('80218')
        expect(page).to have_content('Address Name: Home')
        expect(page).to have_link('Edit Address')
      end

    end
  end
end