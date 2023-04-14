Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

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
