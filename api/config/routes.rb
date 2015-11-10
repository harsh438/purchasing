Rails.application.routes.draw do
  root to: 'frontend#index'

  scope :api, format: true, defaults: { format: :json } do
    resources :purchase_orders, only: :index do
      member do
        post :cancel
      end
      # post ':po_number/cancel/order', to: 'purchase_orders#cancel_order', as: :cancel_order_purchase_order
    end

    resources :purchase_order_line_items, only: :index do
      # post 'update', to: 'purchase_orders#update', as: :purchase_order
      collection do
        post :update
        post :cancel
        post :uncancel
      end
      # post 'cancel', to: 'purchase_orders#cancel', as: :cancel_purchase_order
      # post 'uncancel', to: 'purchase_orders#uncancel', as: :uncancel_purchase_order
    end

    resources :categories, only: :index
    resources :products, only: :index
    resources :vendors, only: :index
    resources :suppliers, only: :index

    get :seasons, to: 'purchase_orders#seasons'
    get :genders, to: 'purchase_orders#genders'
    get :order_types, to: 'purchase_orders#order_types'
  end
end
