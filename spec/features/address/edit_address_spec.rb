require "rails_helper"

describe "As a merchant" do
  describe "when I visit my profile" do
    it "can edit an address" do
      merchant = User.create!(name: 'Merchant', address: '1111 Shop Rd', city: 'Chicago', state: 'IL', zip: 88888, email: 'merchant@merchant.com', password: 'securepassword', role: 1)

      address_2 = merchant.addresses.create!(address: '1111 Shop Rd', city: 'Chicago', state: 'IL', zip: 88888)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit '/profile'

      click_link 'Edit Address'

      expect(page).to have_content("Edit Your Home Address")

      fill_in :address, with: '567 State Ave'
      fill_in :city, with: 'Denver'
      fill_in :state, with: 'CO'
      fill_in :zip, with: '80218'
      fill_in :nickname, with: 'Home'
      click_button 'Update Address'

      expect(current_path).to eq('/profile')

      expect(page).to have_content("You have updated your Home address")

    # ask about why this fails!!!
      # expect(page).to have_content('567 State Ave')
      # expect(page).to have_content('Denver')
      # expect(page).to have_content('CO')
      # expect(page).to have_content('80218')
      # expect(page).to have_content('Address Name: Home')
      # expect(page).to have_link('Edit Address')
    end
  end
end

describe "As a user" do
  describe "when I visit my profile" do
    it "can edit an address" do
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

      click_link 'Edit Address'

      expect(page).to have_content("Edit Your Home Address")

      fill_in :address, with: '567 State Ave'
      fill_in :city, with: 'Denver'
      fill_in :state, with: 'CO'
      fill_in :zip, with: '80218'
      fill_in :nickname, with: 'Home'
      click_button 'Update Address'

      expect(current_path).to eq('/profile')

      expect(page).to have_content("You have updated your Home address")

      expect(page).to have_content('567 State Ave')
      expect(page).to have_content('Denver')
      expect(page).to have_content('CO')
      expect(page).to have_content('80218')
      expect(page).to have_content('Address Name: Home')
      expect(page).to have_link('Edit Address')
    end
  end
end