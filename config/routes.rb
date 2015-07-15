Rails.application.routes.draw do
  root "welcome#index"

  resources :categories, except: :destroy
end
