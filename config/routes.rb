Rails.application.routes.draw do
  get 'reflections/index'
  devise_for :users

  # 未ログイン用トップページ
  root "pages#home"

  # ログイン後のハブ（MyPage）
  get   "mypage", to: "dashboards#show"
  patch "mypage", to: "dashboards#update"

  # 目標実現ページ
  get "goal", to: "goals#show"

  # 道しるべページ
  get   "roadmap", to: "roadmaps#show"
  patch "roadmap", to: "roadmaps#update"

  # 振り返り（テキスト）ページ
  get   "reviews",     to: "reflections#index"
  post  "reviews",     to: "reflections#create"
  patch "reviews/:id", to: "reflections#update", as: :review

  # 習慣＋今日の実行ログ
  resources :habits do
    resource :habit_log, only: [:create, :destroy]
  end
end