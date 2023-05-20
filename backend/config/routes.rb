Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/favorites", to: "favorites#index"

  resources :users do
    collection do
      get "show_other_user/:id", to: "users#show_other_user"
    end
  end
  resources :books do
    resources :favorite_books, only: [:create, :destroy]
    collection do
      get "is_favorite"
    end
    resources :reviews
  end
  resources :reviews do
    resources :favorite_reviews, only: [:create, :destroy]
    collection do
      get "new_reviews"
      get "is_favorite"
    end
  end
  resources :questions do
    resources :favorite_questions, only: [:create, :destroy]
  end
  resources :subject_questions
  resources :replies
  resources :subject_question_replies

end
