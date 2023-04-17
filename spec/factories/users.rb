FactoryBot.define do
  factory :user do
    username { Faker::TvShows::VentureBros.character }
    email { Faker::Internet.email }
    password { Faker::Internet.password  }
    user_type { 0 }
  end
end
