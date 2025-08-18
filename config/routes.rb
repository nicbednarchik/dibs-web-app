Rails.application.routes.draw do
  devise_for :users
  root "clothes#index"

  resources :clothes do
    member do
      post   :dibs
      delete :undibs
    end
  end

  get "/my/listings", to: "clothes#mine", as: :my_listings
  resources :users, only: [ :show, :index ]
end
