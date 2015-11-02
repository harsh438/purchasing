Rails.application.routes.draw do
  root to: 'frontend#index'

  scope :api, format: true, constraints: { format: /json|csv/ } do
    resources :purchase_orders, only: :index
    resources :categories, only: :index
    resources :products, only: :index
    resources :vendors, only: :index

    get :seasons, to: 'purchase_orders#seasons'
    get :genders, to: 'purchase_orders#genders'
    get :order_types, to: 'purchase_orders#order_types'
  end
end
