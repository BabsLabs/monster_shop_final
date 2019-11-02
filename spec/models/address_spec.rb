require 'rails_helper'

describe Address do
  describe "relationships" do
    it {should belong_to :user}
  end

  describe "validations" do
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
    it {should validate_presence_of :nickname}
    it {should validate_uniqueness_of(:nickname).scoped_to(:user_id)}
  end

  describe "model methods" do
    it 'can tell if an address is a defualt address' do
      user = User.create!(name: 'User Dude', address: '123 Fake St', city: 'Denver', state: 'CO', zip: 80008, email: ' user@user.com', password: '12345')
      address = user.addresses.create!(address: '123 Fake St', city: 'Denver', state: 'CO', zip: 80008)
      address_2 = user.addresses.create!(address: '456 Mountain Blvd', city: 'Aspen', state: 'CO', zip: 80345, nickname: 'Mountain House')

      expect(address.not_default_address?).to be_falsy
      expect(address_2.not_default_address?).to be_truthy
    end
  end

end