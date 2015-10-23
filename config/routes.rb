Rails.application.routes.draw do

  root 'pages#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get 'logout' => 'sessions#destroy', as: 'logout'

  resource :user, only: [:edit, :update]
  resources :workouts

  get 'private' => 'pages#private', as: 'private' # FIXME temporary

end
