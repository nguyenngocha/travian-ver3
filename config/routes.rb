Rails.application.routes.draw do

  root "accounts#index"
  get "/error", to: "staticpages#error"
  devise_for :users, path: "", path_names: { sign_in: "login", sign_out: "logout", register: "register" },controllers: {
    sessions: "sessions",
    registrations: "registrations"
  }

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.is_admin? } do
    mount Sidekiq::Web, at: '/sidekiq'
  end

  resources :users
  resources :accounts do
    resources :farm_lists do
      resources :farms
    end
  end
  namespace :admin do
    root "accounts#index"
    resources :proxies
  end
end
