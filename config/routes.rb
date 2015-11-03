Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      resources :customers, only: [:index, :show], defaults: { format: 'json' } do
        collection do
          get :find
          get :find_all
          get :random
        end
      end

      resources :invoices, only: [:index, :show], defaults: { format: 'json' } do
        get :transactions
        get :invoice_items
        get :items
        get :customer
        get :merchant
        collection do
          get :find
          get :find_all
          get :random
        end
      end

      resources :invoice_items, only: [:index, :show], defaults: { format: 'json' } do
        collection do
          get :find
          get :find_all
          get :random
        end
      end

      resources :items, only: [:index, :show], defaults: { format: 'json' } do
        collection do
          get :find
          get :find_all
          get :random
        end
      end

      resources :merchants, only: [:index, :show], defaults: { format: 'json' } do
        get :items
        get :invoices
        collection do
          get :find
          get :find_all
          get :random
        end
      end

      resources :transactions, only: [:index, :show], defaults: { format: 'json' } do
        collection do
          get :find
          get :find_all
          get :random
        end
      end
    end
  end

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
