Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "/users/find_all", to: "users/search#index"
      resources :users, except: [:new]
      resources :wishlist_items, except: [:new]
      resources :organizations, except: [:new]
      post "/login", to: "users#login_user"
    end
  end
end
