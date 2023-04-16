Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "/users/find_all", to: "users/search#index"
      get "/organizations/find_all", to: "organizations/search#index"

      resources :users, except: [:new] do
				resources :wishlist_items, only: :index
      end
      resources :wishlist_items, except: [:new]
      resources :organizations, except: [:new]
      post "/login", to: "users#login_user"
    end
  end
end
