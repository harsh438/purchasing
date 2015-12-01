Rails.application.routes.draw do
  root to: 'frontend#index'

  scope :api, format: true, defaults: { format: :json } do
    resources :orders, only: [:index, :show, :create, :update] do
      collection do
        post :export
      end
    end

    resources :order_line_items, only: [:destroy, :update]

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

    scope :filters do
      get ':action' => 'filters#:action'
    end

    resources :products, only: :show
    resources :skus, only: [:index, :create, :show]
    resources :suppliers, only: [:index, :create, :update, :show]
    resources :vendors, only: [:index, :create, :show, :update]
  end
end
