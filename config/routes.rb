Rails.application.routes.draw do

  root 'pages#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get 'logout' => 'sessions#destroy', as: 'logout'

  resource :user, only: [:edit, :update]
  resources :workouts do
    member do
      get :do
      delete :undo
    end
    resource :strava, controller: 'workout_strava_activities'
  end

end
