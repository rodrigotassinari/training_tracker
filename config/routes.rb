Rails.application.routes.draw do

  root 'pages#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get 'logout' => 'sessions#destroy', as: 'logout'

  resource :user, only: [:edit, :update]
  resources :workouts do
    member do
      get :do
      get :do_strava
      delete :undo
    end
  end

end
