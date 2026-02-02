Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # Static pages
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Explore (browse all products)
  get "explore", to: "explore#index"
  get "explore/:id", to: "explore#show", as: :explore_product

  # Search flow
  resources :searches, only: [:new, :create, :edit, :update, :show] do
    get :processing, on: :member  # Shows loading state while AI processes
    get "products/:id", to: "matches#show_product", as: :product
    resources :matches, only: [:index, :show]
  end

  # Wishlist actions on products
  resources :comparison_products, only: [] do
    post :add_to_wishlist, to: "wishlist_items#create", on: :member
    delete :remove_from_wishlist, to: "wishlist_items#destroy", on: :member
  end

  # User profiles and wishlists
  resources :users, only: [:show, :edit, :update] do
    resources :wishlist_items, only: [:index, :show, :destroy]
    get "wishlist", to: "wishlists#index", on: :member
  end
end
