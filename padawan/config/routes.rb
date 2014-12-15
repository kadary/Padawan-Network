Rails.application.routes.draw do
  resources :messages

  resources :users
  resources :sessions
  resources :statuses
  
  root :to => 'navigation#accueil'
  
  get 'navigation/profile'

  get 'navigation/message'

  get 'navigation/apropos'
  
  #Sessions Users
  get "logout_user" => "sessions#destroy", :as => "logout_user"
  post "login_user" => "sessions#new", :as => "login_user"
  
  #Users
  get "signup" => "users#new", :as => "signup"
  
  #Status
  get "refresh"  => "navigation#refreshstatuses", :as => "refresh"
  get "votedup"  => "navigation#votedup", :as => "votedup"
  get "voteddown"  => "navigation#voteddown", :as => "voteddown"


  

  

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
