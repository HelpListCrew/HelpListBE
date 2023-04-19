# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
organization = FactoryBot.create(:organization, mission_statement: "To empower and uplift individuals, families, and communities in need through comprehensive support, compassionate care, and sustainable solutions.")
org2 = FactoryBot.create(:organization, mission_statement: nil)

organization.users.create!(email: "recipient3@gmail.com", password: "123", user_type: 1)
organization.users.create!(email: "anotherrecipient3@gmail.com", username: "OceanicDreamer", password: "123", user_type: 1)
organization.users.create!(email: "123@gmail.com", username: "Stargazer321", password: "123", user_type: 1)

org2.users.create!(email: "456@gmail.com", username: "Stargazer321", password: "321", user_type: 1)
org2.users.create!(email: "789@gmail.com", username: "CloudWatcher88", password: "321", user_type: 1)
org2.users.create!(email: "987@gmail.com", username: nil, password: "321", user_type: 1)


donor = User.create!(email: "donor3@gmail.com", password: "123")

# User.first.wishlist_items.create!(api_item_id: 1)

# DonorItem.create!(donor: donor, wishlist_item: WishlistItem.first)

FactoryBot.create(:organization, street_address: "6475A Benton St.", city: "Arvada", state: "CO", zip_code: 80003)
FactoryBot.create(:organization, street_address: "1535 High St.", city: "Denver", state: "CO", zip_code: 80218)
FactoryBot.create(:organization, street_address: "3805 Marshall St.", city: "Wheat Ridge", state: "CO", zip_code: 80033)
FactoryBot.create(:organization, street_address: "3489 W. 72nd Ave.", city: "Westminster", state: "CO", zip_code: 80030)
FactoryBot.create(:organization, street_address: "1101 W. 7th Ave.", city: "Denver", state: "CO", zip_code: 80204)
FactoryBot.create(:organization, street_address: "1600 N. Downing St.", city: "Denver", state: "CO", zip_code: 80218)
FactoryBot.create(:organization, street_address: "1330 Fox St.", city: "Denver", state: "CO", zip_code: 80204)
FactoryBot.create(:organization, street_address: "3301 S. Grant St.", city: "Englewood", state: "CO", zip_code: 80113)
FactoryBot.create(:organization, street_address: "2100 Stout St.", city: "Denver", state: "CO", zip_code: 80205)

FactoryBot.create(:organization, street_address: "2301 Lawrence St.", city: "Denver", state: "CO", zip_code: 80205)
organization = FactoryBot.create(:organization, street_address: "2323 Curtis St.", city: "Denver", state: "CO", zip_code: 80205)

organization.users.create!(email: "organization_recipient@gmail.com", password: "123", user_type: 1)