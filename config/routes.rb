Rails.application.routes.draw do

  root 'pages#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get 'logout' => 'sessions#destroy', as: 'logout'

  resource :user, only: [:edit, :update]
  resources :workouts do
    member do
      get :do
      get :do_strava
      get :strava_activities
      delete :undo
    end
    resources :shares, only: [:new, :create], controller: 'workout_shares'
  end

  get '/workout/:token' => 'public_workouts#show', as: 'public_workout'

end
