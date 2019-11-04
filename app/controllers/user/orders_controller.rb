class User::OrdersController < ApplicationController
  before_action :exclude_admin

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    if current_user.has_no_addresses?
      flash[:error] = 'You must add an address to checkout!'
      redirect_to '/profile/addresses/new'
    else
      order = current_user.orders.new(address_id: params[:address_id])
      order.save
        cart.items.each do |item|
          order.order_items.create({
            item: item,
            quantity: cart.count_of(item.id),
            price: item.price
            })
        end
      session.delete(:cart)
      flash[:notice] = "Order created successfully!"
      redirect_to '/profile/orders'
    end
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.cancel
    redirect_to "/profile/orders/#{order.id}"
  end

  def edit_address
    @order = current_user.orders.find(params[:id])
    @address_options = current_user.addresses.map{ |a| [ a.nickname, a.id ] }
  end

  def update_address
    order = current_user.orders.find(params[:id])
    order.update_attributes(address_id: params[:address_id])
    redirect_to "/profile/orders"
  end
end
