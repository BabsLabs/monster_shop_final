require 'rails_helper'

RSpec.describe User do
  describe 'Relationships' do
    it {should belong_to(:merchant).optional}
    it {should have_many :orders}
    it {should have_many :addresses}
  end

  describe 'Validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
    it {should validate_presence_of :email}
    it {should validate_uniqueness_of :email}
  end

  describe "methods" do
    it "can check if it has any addresses" do
      @user = User.create!(name: 'Brian', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'Brian@example.com', password: 'securepassword')
      @user_2 = User.create!(name: 'Tony', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'Tony@example.com', password: 'securepassword')
      @address = @user.addresses.create!(address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)

      expect(@user.has_no_addresses?).to be_falsy
      expect(@user_2.has_no_addresses?).to be_truthy
    end

  end
end
