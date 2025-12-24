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

  # =========================
  # 振り返り（記入＆検索）
  # =========================
  resource :reviews, only: [:show, :update], controller: "reflections"
  get "reviews/search", to: "reflections#search", as: :reviews_search

  # link①〜④（※「記入ページ」に飛ばす想定）
  get "reviews/morning", to: "reflections#show", defaults: { type: "morning" }, as: :morning_reviews
  get "reviews/night",   to: "reflections#show", defaults: { type: "night" },   as: :night_reviews
  get "reviews/today",   to: "reflections#show", defaults: { type: "today" },   as: :today_reviews
  get "reviews/week",    to: "reflections#show", defaults: { type: "week" },    as: :weekly_reviews

  # =========================
  # 習慣
  # =========================
  resources :habits do
    resource :habit_log, only: [:create, :destroy]
  end
end

