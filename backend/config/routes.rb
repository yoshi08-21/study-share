Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


  resources :users
  resources :books
  resources :reviews
  resources :questions
end
