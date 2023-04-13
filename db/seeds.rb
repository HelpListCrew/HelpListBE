# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
organization = FactoryBot.create(:organization)
organization.users.create!(email: "recipient@gmail.com", password: "123", user_type: 1)

donor = User.create!(email: "donor@gmail.com", password: "123")

User.first.wishlist_items.create!(api_item_id: 1)

DonorItem.create!(donor: donor, wishlist_item: WishlistItem.first)
