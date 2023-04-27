Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


  resources :users
  resources :books do
    resources :favorite_books, only: [:create, :destroy]
    collection do
      get "is_favorite"
    end
    resources :reviews
  end
  resources :reviews do
    collection do
      get "new_reviews"
    end
  end
  resources :questions do
    resources :favorite_questions, only: [:create, :destroy]
  end
  resources :subject_questions
  resources :replies
  resources :subject_question_replies

end
