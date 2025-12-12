Rails.application.routes.draw do
  devise_for :users

  root "pages#home"

  # 検索（一覧・検索結果）画面
  get "reviews", to: "reviews#index"

  # MyPage
  get   "mypage", to: "dashboards#show"
  patch "mypage", to: "dashboards#update"

  # 目標実現
  get "goal", to: "goals#show"

  # 道しるべ
  get   "roadmap", to: "roadmaps#show"
  patch "roadmap", to: "roadmaps#update"

  # 振り返り（編集画面）
  get   "review", to: "reflections#show"
  patch "review", to: "reflections#update"

  # 実行率グラフ
  get "analytics", to: "analytics#show"

  # 習慣
  resources :habits do
    resource :habit_log, only: [:create, :destroy]
  end
end