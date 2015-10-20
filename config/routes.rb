Rails.application.routes.draw do

  root 'pages#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get 'logout' => 'sessions#destroy', as: 'logout'

  get 'private' => 'pages#private', as: 'private' # FIXME temporary

end
