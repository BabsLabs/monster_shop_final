require "rails_helper"

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