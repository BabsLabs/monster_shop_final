require "rails_helper"

describe "As a user" do
  describe "when I visit my profile" do
    it "can update the address of an order that has been placed" do
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @brian.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )

      @user = User.create!(name: 'Cliff Hanger', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'cliff@example.com', password: 'securepassword')
      @address = @user.addresses.create!(address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit item_path(@ogre)

      click_button 'Add to Cart'

      visit '/cart'

      click_button 'Check Out'

      click_link "Edit Shipping Address"

      click_button "Update Address"

      expect(current_path).to eq('/profile/orders')
    end
  end
end