Rails.application.routes.draw do
  get 'roadmaps/show'
  get 'goals/show'
  devise_for :users

  # 未ログイン用トップページ
  root "pages#home"
  get   "roadmap", to: "roadmaps#show"
  patch "roadmap", to: "roadmaps#update"

  # ログイン後のハブ（MyPage）
  get   "mypage", to: "dashboards#show"
  patch "mypage", to: "dashboards#update"

  # 目標実現ページ
  get "goal", to: "goals#show"

  resources :habits do
  resource :habit_log, only: [:create, :destroy]
  end
end