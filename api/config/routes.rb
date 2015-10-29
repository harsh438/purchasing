Rails.application.routes.draw do
  root to: 'frontend#index'

  scope :api, format: true, constraints: { format: :json } do
    resources :purchase_orders, only: :index
    resources :products, only: :index
    resources :vendors, only: :index

    get :seasons, to: 'purchase_orders#seasons'
  end
end
