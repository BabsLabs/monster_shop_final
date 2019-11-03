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

end