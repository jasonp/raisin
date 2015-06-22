require 'sidekiq/web'
Rails.application.routes.draw do

  get 'updates/index'

  get 'updates/new'

  get 'updates/create'

  get 'updates/show'

  get 'updates/update'

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks', registrations: 'users/registrations' }
  resources :users, only: [:show, :edit, :update]
  
  get '/accounts/:account_id/projects/:project_id/lists/completed/', to: 'lists#completed', as: "account_project_lists_completed"
  
  resources :accounts, only: [:new, :show, :edit, :create, :update, :index] do
    get 'users', on: :member
    resources :projects do
      resources :conversations
      resources :lists, only: [:create, :update, :destroy, :show, :new] do
        resources :items, only: [:new, :create, :update, :destroy, :show]
      end
    end
    resources :members
    resources :comments
  end
        
        
  get '/beta', to: 'pages#beta', as: 'beta'
  get '/help', to: 'pages#help', as: 'help'
  get '/welcome', to: 'accounts#new', as: 'welcome'
  
  resources :subscriptions, only: [:new, :create, :edit, :update]
  
  get '/accounts/:account_id/recently', to: 'accounts#recently', as: 'account_recently'
  get '/accounts/:account_id/createdorder', to: 'accounts#createdorder', as: 'account_createdorder'
  get '/accounts/:account_id/alphabetical', to: 'accounts#alphabetical', as: 'account_alphabetical'

  
  get '/accounts/:account_id/archive', to: 'accounts#archive', as: 'account_project_archive'

  # special ajax routes for to-do lists
  get '/accounts/:account_id/projects/:project_id/cancel', to: 'lists#cancel', as: "account_project_cancel_list", :defaults => { :format => 'js' }
  get '/accounts/:account_id/projects/:project_id/lists/:list_id/cancel', to: 'items#cancel', as: "account_project_list_cancel_item", :defaults => { :format => 'js' }
  
  # mount griddler using default path: /email_processor
  mount_griddler

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'pages#home'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
