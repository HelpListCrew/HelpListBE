Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      resources :users, except: [:new, :destroy]
      resources :wishlist_items, only: [:show, :index, :create, :update, :destroy]
      post "/login", to: "users#login_user"
    end
  end

end
