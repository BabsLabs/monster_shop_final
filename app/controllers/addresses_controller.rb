class AddressesController < ApplicationController
  before_action :exclude_admin

  def new
  end

  def create
    user = current_user
    address = current_user.addresses.create!(address_params)
    redirect_to '/profile'
  end

  private

  def address_params
    params.permit(:name, :address, :city, :state, :zip, :nickname)
  end

end