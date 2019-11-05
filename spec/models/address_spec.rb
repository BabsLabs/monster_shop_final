require 'rails_helper'

describe Address do
  describe "relationships" do
    it {should belong_to :user}
    it {should have_many :orders}
  end

  describe "validations" do
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
    it {should validate_presence_of :nickname}
    it {should validate_uniqueness_of(:nickname).scoped_to(:user_id)}
  end

  describe "methods" do
    it "can check if it has any shipped orders" do
      user = User.create!(name: 'Cliff Hanger', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'cliff@example.com', password: 'securepassword')
      address = user.addresses.create!(address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      address_2 = user.addresses.create!(address: '9999 State Blvd', city: 'Aspen', state: 'CO', zip: 80222, nickname: 'Cabin')

      brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      hippo = brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )

      order_1 = user.orders.create!(status: 'shipped', address_id: address.id)
      order_item_1 = order_1.order_items.create!(item: hippo, price: hippo.price, quantity: 2, fulfilled: true)

      order_2 = user.orders.create!(status: 'pending', address_id: address_2.id)
      order_item_2 = order_2.order_items.create!(item: hippo, price: hippo.price, quantity: 2, fulfilled: false)

      expect(address.no_shipped_orders?).to be_falsy
      expect(address_2.no_shipped_orders?).to be_truthy
    end

    it "can check if it has any orders" do
      user = User.create!(name: 'Cliff Hanger', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'cliff@example.com', password: 'securepassword')
      address = user.addresses.create!(address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      address_2 = user.addresses.create!(address: '9999 State Blvd', city: 'Aspen', state: 'CO', zip: 80222, nickname: 'Cabin')

      brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      hippo = brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )

      order_1 = user.orders.create!(status: 'shipped', address_id: address.id)
      order_item_1 = order_1.order_items.create!(item: hippo, price: hippo.price, quantity: 2, fulfilled: true)

      expect(address.no_orders?).to be_falsy
      expect(address_2.no_orders?).to be_truthy
    end
  end

end