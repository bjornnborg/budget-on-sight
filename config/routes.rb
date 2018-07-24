Rails.application.routes.draw do

  devise_for :users
  resources :transactions
  resources :categories

  root :to => redirect("/users/sign_in")
end
