# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
hippo = brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )

admin = User.create!(name: 'Andy Admin', address: '123 Fake St', city: 'Denver', state: 'CO', zip: 80111, email: 'admin@admin.com', password: 'password', role: 2)
address_1 = admin.addresses.create!(address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)

maggie = User.create!(name: 'Maggie Merchant', address: '456 Real Blvd', city: 'Aurora', state: 'CO', zip: 80112, email: 'merchant@merchant.com', password: 'password', role: 1)
address_2 = maggie.addresses.create!(address: '456 Real Blvd', city: 'Aurora', state: 'CO', zip: 80112)

user = User.create!(name: 'Ursula User', address: '9999 Happy Ln', city: 'Aspen', state: 'CO', zip: 80456, email: 'user@user.com', password: 'password')
address_3 = user.addresses.create!(address: '9999 Happy Ln', city: 'Aspen', state: 'CO', zip: 80456)
address_4 = user.addresses.create!(address: '77777 Western Rn', city: 'Leadville', state: 'CO', zip: 80555, nickname: 'Leadville House' )

order_1 = user.orders.create!(status: 'shipped', address_id: address_3.id)
order_item_1 = order_1.order_items.create!(item: hippo, price: hippo.price, quantity: 2, fulfilled: true)

order_2 = user.orders.create!(status: 'pending', address_id: address_4.id)
order_item_2 = order_2.order_items.create!(item: hippo, price: hippo.price, quantity: 2, fulfilled: false)
