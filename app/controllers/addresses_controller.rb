class AddressesController < ApplicationController
  before_action :exclude_admin

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

  def edit
    @address = Address.find(params[:id])
  end

  def update
    address = Address.find(params[:id])
    if address.update!(address_params)
      flash[:success] = "You have updated your #{address.nickname.capitalize} address"
      redirect_to '/profile'
    else
      flash.now[:error] = address.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def address_params
    params.permit(:name, :address, :city, :state, :zip, :nickname)
  end

end