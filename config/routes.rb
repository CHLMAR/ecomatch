Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "about", to: "pages#about", as: :about
  get "contact", to: "pages#contact", as: :contact
  get "explore", to: "explore#index"
  get "explore/:id", to: "explore#show", as: :explore_product

  # Defines the root path route ("/")
  # root "posts#index"

  resources :searches, only: [:new, :create, :edit, :update, :show] do
    get "products/:id", to: "matches#show_product", as: :product
    resources :matches, only: [:index, :show]
  end

  resources :comparison_products, only: [] do
    member do
      post :add_to_wishlist, to: "wishlist_items#create"
      delete :remove_from_wishlist, to: "wishlist_items#destroy"
    end
  end

  resources :users, only: [:show, :edit, :update] do
    resources :wishlist_items, only: [:index, :show, :destroy]
    get 'wishlist', to: 'wishlists#index', on: :member
  end
end
