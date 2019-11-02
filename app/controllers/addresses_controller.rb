class AddressesController < ApplicationController
  before_action :exclude_admin_and_merchants

  def new
  end

  def create
    user = current_user
    address = current_user.addresses.create(address_params)
    if address.save
      flash[:success] = "You have successfully added an address!"
      redirect_to '/profile'
    else
      flash.now[:error] = address.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def address_params
    params.permit(:name, :address, :city, :state, :zip, :nickname)
  end

end