# config/routes.rb
Rails.application.routes.draw do
  devise_for :users

  root "pages#home"

  # MyPage
  get   "mypage", to: "dashboards#show"
  patch "mypage", to: "dashboards#update"

  # 目標実現
  get "goal", to: "goals#show"

  # 道しるべ
  get   "roadmap", to: "roadmaps#show"
  patch "roadmap", to: "roadmaps#update"

  # 振り返り（Reflections）
get   "reviews", to: "reflections#show"
patch "reviews", to: "reflections#update"


  # 実行率グラフ（同ページにも出すけど、ルートは残してOK）
  get "analytics", to: "analytics#show"

  # 習慣
  resources :habits do
    resource :habit_log, only: [:create, :destroy]
  end
end