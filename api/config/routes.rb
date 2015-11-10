Rails.application.routes.draw do
  root to: 'frontend#index'
  get :orders, to: 'frontend#index'

  scope :api, format: true, defaults: { format: :json } do
    resources :orders, only: :index

    resources :purchase_orders, only: :index do
      member do
        post :cancel
      end
    end

    resources :purchase_order_line_items, only: :index do
      collection do
        post :update
        post :cancel
        post :uncancel
      end
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
