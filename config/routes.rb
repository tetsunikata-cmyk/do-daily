Rails.application.routes.draw do
  get 'dashboards/show'
  devise_for :users

  root "habits#index"

  get "mypage", to: "dashboards#show" 

  resources :habits do
    resource :habit_log, only: [:create, :destroy]
  end
end