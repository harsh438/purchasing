Rails.application.routes.draw do
  root to: 'frontend#index'

  scope :api do
    scope :purchase_orders, constraints: { format: :json } do
      post 'cancel', to: 'purchase_orders#cancel', as: :cancel_purchase_order
      post 'uncancel', to: 'purchase_orders#uncancel', as: :uncancel_purchase_order
      post 'update', to: 'purchase_orders#update', as: :purchase_order
      post ':po_number/cancel/order', to: 'purchase_orders#cancel_order', as: :cancel_order_purchase_order
    end
  end

  scope :api, format: true, constraints: { format: /json|csv/ } do
    resources :purchase_orders, only: :index
    resources :categories, only: :index
    resources :products, only: :index
    resources :vendors, only: :index
    resources :suppliers, only: :index

    get 'purchase_orders/summary', to: 'purchase_orders#summary'
    get :seasons, to: 'purchase_orders#seasons'
    get :genders, to: 'purchase_orders#genders'
    get :order_types, to: 'purchase_orders#order_types'
  end
end
