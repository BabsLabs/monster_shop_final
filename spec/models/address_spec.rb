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
  end

end