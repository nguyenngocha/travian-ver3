Rails.application.routes.draw do

  root "accounts#index"
  get "/error", to: "staticpages#error"
  devise_for :users, path: "", path_names: { sign_in: "login", sign_out: "logout", register: "register" },controllers: {
    sessions: "sessions",
    registrations: "registrations"
  }

  resources :users
  resources :accounts do
    resources :farm_lists do
      resources :farms
    end
  end
  resources :proxies
end
