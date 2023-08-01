Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/favorites", to: "favorites#index"
  delete "/favorite_books/destroy_from_item_list", to: "favorite_books#destroy_from_item_list"

  resources :pages, only: [:index] do
    collection do
      get "new_reviews"
      get "popular_books"
      get "get_same_university_books"
    end
  end

  resources :users do
    collection do
      get "show_other_user/:id", to: "users#show_other_user"
      patch "save_user_memo"
      get "check_existence"
    end
  end
  resources :books, only: [:index, :show, :create, :update, :destroy] do
    resources :favorite_books, only: [:create, :destroy]
    collection do
      get "is_favorite"
      get "search_books"
      get "check_existence"

    end
    resources :reviews, only: [:index, :show, :create, :update, :destroy]
    resources :questions, only: [:index, :show, :create, :update, :destroy] do
      resources :replies, only: [:index, :show, :create, :update, :destroy]
    end

  end
  resources :reviews do
    resources :favorite_reviews, only: [:create, :destroy]
    collection do
      get "is_favorite"
      get "check_existence"
    end
  end
  resources :questions, only: [:index] do
    resources :favorite_questions, only: [:create, :destroy]
    collection do
      get "is_favorite"
      get "all_questions"
      get "search_questions"
      get "check_existence"
    end
  end
  resources :replies, only: [:index] do
    resources :favorite_replies, only: [:create, :destroy]
    collection do
      get "is_favorite"
      get "check_existence"
    end
  end
  resources :subject_questions do
    resources :favorite_subject_questions, only: [:create, :destroy]
    resources :subject_question_replies
    collection do
      get "is_favorite"
      get "search_subject_questions"
      get "questions_to_specific_subject"
      get "check_existence"
    end
  end

  resources :subject_question_replies, only: [:index] do
    resources :favorite_subject_question_replies, only: [:create, :destroy]
    collection do
      get "is_favorite"
      post "create_sample_notification"
      get "check_existence"
    end
  end
  resources :browsing_histories, only: [:index]
  resources :notifications, only: [:index] do
    collection do
      get "check_unread_notifications"
    end
  end

  resources :surveys, only: [:index, :show, :create, :update, :destroy]


end
