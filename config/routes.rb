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

  # 振り返り
  get   "reviews",        to: "reflections#show"    # 振り返りの記入（1日分）
  patch "reviews",        to: "reflections#update"  # 保存
  get   "reviews/search", to: "reflections#search"  # 振り返り検索（編集不可）

  # 習慣
  resources :habits do
  resource :habit_log, only: [:create, :destroy]

  # 振り返りショートカット（link①〜④用）
  get "/reviews/morning", to: "reflections#search", defaults: { type: "morning" }, as: :morning_reviews
  get "/reviews/night",   to: "reflections#search", defaults: { type: "night" },   as: :night_reviews
  get "/reviews/today",   to: "reflections#search", defaults: { type: "today" },   as: :today_reviews
  get "/reviews/week",    to: "reflections#search", defaults: { type: "week" },    as: :weekly_reviews


  resource :reviews, only: [:show, :update], controller: "reflections"
get "reviews/search", to: "reflections#search", as: :reviews_search

  end
end

