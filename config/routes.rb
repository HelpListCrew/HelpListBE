Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
			post "/login", to: "users#login_user"
      resources :users, only: [:create, :show]
    end
  end
end
