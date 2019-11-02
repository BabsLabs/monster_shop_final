class Address < ApplicationRecord
  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
  validates_presence_of :nickname
  validates_uniqueness_of :nickname, scope: :user_id

  belongs_to :user

  def not_default_address?
    self.nickname != 'Default'
  end
end