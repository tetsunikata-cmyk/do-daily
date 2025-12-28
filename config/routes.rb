Rails.application.routes.draw do
  devise_for :users
  root "pages#home"

  get   "mypage", to: "dashboards#show"
  patch "mypage", to: "dashboards#update"

  get "goal", to: "goals#show"

  get   "roadmap", to: "roadmaps#show"
  patch "roadmap", to: "roadmaps#update"

  # 振り返り（記入）
  get   "reviews",        to: "reflections#show"
  patch "reviews",        to: "reflections#update"

  # 振り返り（検索）
  get   "reviews/search", to: "reflections#search", as: :reviews_search

  # link①〜④（記入ページへ飛ばす）
  get "reviews/morning", to: "reflections#show", defaults: { type: "morning" }, as: :morning_reviews
  get "reviews/night",   to: "reflections#show", defaults: { type: "night" },   as: :night_reviews
  get "reviews/today",   to: "reflections#show", defaults: { type: "today" },   as: :today_reviews
  get "reviews/week",    to: "reflections#show", defaults: { type: "week" },    as: :weekly_reviews

  resources :habits do
  resource :habit_log, only: [:create, :destroy]

  get "schedule", to: "schedules#month"
  get "schedule/week", to: "schedules#week"
  get "schedule/day", to: "schedules#day"

resources :schedule_events, only: [:create, :update, :destroy]
  end
end

