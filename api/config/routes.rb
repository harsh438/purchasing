Rails.application.routes.draw do
  root to: 'frontend#index'

  scope :api, format: true, contraints: { format: :json } do
    resources :purchase_orders, only: :index
    resources :products, only: :index
  end
end
