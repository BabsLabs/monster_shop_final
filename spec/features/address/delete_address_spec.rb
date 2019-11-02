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
  describe "when I visit my profile" do
    it "cannot see a link to delete my Default address" do
      user = User.create!(name: 'Merchant', address: '1111 Shop Rd', city: 'Chicago', state: 'IL', zip: 88888, email: 'merchant@merchant.com', password: 'securepassword')
      address = user.addresses.create!(address: '1111 Shop Rd', city: 'Chicago', state: 'IL', zip: 88888)
      address = user.addresses.create!(address: '6578 American St', city: 'Denver', state: 'CO', zip: 80999, nickname: 'Denver House')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/profile'

      address_1 = user.addresses.first

      within "#address-#{address_1.id}" do
        expect(page).to have_content("Address Name: Default")
        expect(page).to_not have_link("Delete Address")
      end

      address_2 = user.addresses.last

      within "#address-#{address_2.id}" do
        expect(page).to have_content("Address Name: Denver House")
        expect(page).to have_link("Delete Address")
      end
    end
  end
end