require 'rails_helper'

RSpec.describe "As a user" do
  describe "when I register" do
    it "adds my address to my address database as my home address" do
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

      expect(current_path).to eq(profile_path)

      within ".addresses" do
        expect(page).to have_content("Name: Home")
        expect(page).to have_content("456 Mountain St")
        expect(page).to have_content("Aspen")
        expect(page).to have_content("CO")
        expect(page).to have_content("80218")
      end

    end
  end
end