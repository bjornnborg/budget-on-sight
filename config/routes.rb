Rails.application.routes.draw do

  devise_for :users
  resources :transactions do
    collection do
      get 'missing'
      get 'report'
      get 'report/detail', action: 'report_detail'
      post 'dismiss'
    end
  end
  resources :categories

  root :to => redirect("/users/sign_in")
end
