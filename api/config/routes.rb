Rails.application.routes.draw do
  root to: 'frontend#index'

  scope :api, format: true, defaults: { format: :json } do
    resources :skus, only: [:index, :create, :show, :update] do
      collection do
        get :supplier_summary
      end
    end

    resources :barcodes do
      collection do
        post :import
      end
    end

    resources :orders, only: [:index, :show, :create, :update] do
      collection do
        post :export
      end
    end

    resources :order_line_items, only: [:destroy, :update]

    resources :purchase_orders, only: [:index, :show] do
      member do
        post :cancel
      end

      collection do
        get :list
      end
    end

    resources :purchase_order_line_items, only: :index do
      collection do
        post :update
        post :cancel
        post :uncancel
      end
    end

    resources :suppliers, only: [:index, :create, :update, :show]
    resources :supplier_terms, only: [:index, :show]

    resources :vendors, only: [:index, :create, :show, :update]

    resources :goods_received_notices, except: [:new, :edit]

    scope :filters do
      get ':action' => 'filters#:action'
    end
  end
end
