Rails.application.routes.draw do
  root to: 'frontend#index'

  scope :api do
    post 'cancel/', to: 'purchase_orders#cancel'
    post 'cancel/:id/order', to: 'purchase_orders#cancel_order'
    post 'purchase_orders/:id/update', to: 'purchase_orders#update', as: :purchase_order
  end

  scope :api, format: true, constraints: { format: /json|csv/ } do
    resources :purchase_orders, only: :index
    resources :categories, only: :index
    resources :products, only: :index
    resources :vendors, only: :index
    resources :suppliers, only: :index

    get :seasons, to: 'purchase_orders#seasons'
    get :genders, to: 'purchase_orders#genders'
    get :order_types, to: 'purchase_orders#order_types'
  end
end
