Rails.application.routes.draw do
  devise_for :users

  root "habits#index"

  resources :habits do
    resource :habit_log, only: [:create, :destroy]
  end
end