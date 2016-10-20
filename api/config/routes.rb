Rails.application.routes.draw do
  root to: 'frontend#index'

  get :status, to: 'application_status#index'

  scope :api, format: true, defaults: { format: :json } do
    resources :skus, only: [:index, :create, :show, :update] do
      collection do
        get :supplier_summary
        post :duplicate
      end
    end

    resources :barcodes, only: [:update] do
      collection do
        post :import
      end
    end

    resources :goods_received_notices, except: [:new, :edit] do
      member do
        post :combine
        delete :delete_packing_list
      end
    end

    resources :orders, only: [:index, :show, :create, :update] do
      collection do
        post :export
      end
    end

    resources :order_line_items, only: [:update, :destroy]

    resources :packing_lists, only: :index

    resources :refused_deliveries_logs, only: [:index, :create, :update]

    resources :elements, only: :index

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

    resources :users, only: [:index]

    resources :over_purchase_orders, only: [:create]

    scope :filters do
      get ':action' => 'filters#:action'
    end

    namespace :hub do
      resources :goods_in, only: [:create]
      resources :assets, only: [:create]
      resources :purchase_orders do
        collection do
          post :latest
        end
      end
      resources :brands do
        collection do
          post :latest
        end
      end
      resources :skus do
        collection do
          post :latest
        end
      end
      resources :products do
        collection do
          post :latest
        end
      end
    end
  end
end
