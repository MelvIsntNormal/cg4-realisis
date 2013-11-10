Client::Application.routes.draw do
  root  'static_pages#index'
  
  scope '/hk' do
    get '/' => 'housekeeping#index'
    match '/users/list',      to: 'housekeeping#users',           via: 'get'
    match '/users/:name',     to: 'housekeeping#showuser',        via: 'get'
    match '/tickets/list',    to: 'housekeeping#tickets',         via: 'get'
    match '/tickets/:id',     to: 'housekeeping#showticket',      via: 'get'
    match '/users/:name',     to: 'housekeeping#updateuser',      via: 'patch'
    match '/tickets/:id',     to: 'housekeeping#updateticket',    via: 'patch'
    match '/users/:name/rm',  to: 'users#destroy',                via: 'delete'
    match '/tickets/:id/rm',  to: 'tickets#destroy',              via: 'delete'
  end
  
  match '/play',            to: 'game_client#play',     via: 'get'
  match '/chat_messages',   to: 'chat_message#index',   via: 'get'
  match '/logout',          to: 'sessions#destroy',     via: 'delete'
  match '/jdebug',          to: 'static_pages#jdebug',  via: 'get'
  match '/cp',              to: 'application#cp',       via: 'get'
  match '/register',        to: 'users#new',            via: 'get'
  match '/me',              to: 'users#me',             via: 'get'
  match '/controlpanel',    to: 'users#controlpanel',   via: 'get'
  match '/:name/edit',      to: 'users#edit',           via: 'get'
  match '/:name' ,          to: 'users#show',           via: 'get'
  match '/:name/:username', to: 'characters#show',      via: 'get'
  match '/:name' ,          to: 'users#update',         via: 'patch'
  
  resources :sessions, only: [:new, :create, :destroy]
  resources :relations, only: [:create, :destroy]
  resources :users do
    resources :characters
  end
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
