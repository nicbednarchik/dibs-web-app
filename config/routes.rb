# config/routes.rb
Rails.application.routes.draw do
  # ========== Devise (auth) ==========
  # Exposes sign up, log in, log out, edit profile, etc.
  devise_for :users

  # ========== Homepage ==========
  root "clothes#index"

  # ========== Clothes (CRUD + dibs) ==========
  resources :clothes do
    member do
      post   :dibs
      delete :undibs
    end
    collection do
      get :my_dibs
    end
  end

  # Current user's listings
  get "/my/listings", to: "clothes#mine", as: :my_listings

  # ========== Users (public profiles + search) ==========
  # Constrain :id to digits so /users/edit isn't swallowed by users#show
  resources :users, only: [ :index, :show ], constraints: { id: /\d+/ }
end
