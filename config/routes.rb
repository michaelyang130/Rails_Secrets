Rails.application.routes.draw do
  root 'sessions#login'

  resources :users 

  resources  :secrets

  post '/sessions/login'

  post '/sessions/logout'

  get '/sessions/new'

  get '/secrets' => 'secrets#index'

  post '/secrets' => 'secrets#create'

  delete '/secrets/:id' => 'secrets#destroy'

  post '/likes' => 'likes#create'

  delete '/likes' => 'likes#destroy'



# Prefix Verb   URI Pattern                 Controller#Action
#            root GET    /                           sessions#login
#           users GET    /users(.:format)            users#index
#                 POST   /users(.:format)            users#create
#        new_user GET    /users/new(.:format)        users#new
#       edit_user GET    /users/:id/edit(.:format)   users#edit
#            user GET    /users/:id(.:format)        users#show
#                 PATCH  /users/:id(.:format)        users#update
#                 PUT    /users/:id(.:format)        users#update
#                 DELETE /users/:id(.:format)        users#destroy
#         secrets GET    /secrets(.:format)          secrets#index
#                 POST   /secrets(.:format)          secrets#create
#      new_secret GET    /secrets/new(.:format)      secrets#new
#     edit_secret GET    /secrets/:id/edit(.:format) secrets#edit
#          secret GET    /secrets/:id(.:format)      secrets#show
#                 PATCH  /secrets/:id(.:format)      secrets#update
#                 PUT    /secrets/:id(.:format)      secrets#update
#                 DELETE /secrets/:id(.:format)      secrets#destroy
#  sessions_login POST   /sessions/login(.:format)   sessions#login
# sessions_logout POST   /sessions/logout(.:format)  sessions#logout
#    sessions_new GET    /sessions/new(.:format)     sessions#new
#                 GET    /secrets(.:format)          secrets#index
#                 POST   /secrets(.:format)          secrets#create
#                 DELETE /secrets/:id(.:format)      secrets#destroy

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
