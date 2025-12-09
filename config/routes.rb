Rails.application.routes.draw do
  get 'dashboards/show'
  devise_for :users

  root "habits#index"

  get   "mypage", to: "dashboards#show"
  patch "mypage", to: "dashboards#update"

  resources :habits do
    resource :habit_log, only: [:create, :destroy]
  end
end