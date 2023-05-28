class User < ApplicationRecord

  has_many :books
  has_many :reviews, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :subject_questions, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :subject_question_replies, dependent: :destroy
  has_many :favorite_books, dependent: :destroy
  has_many :fav_books,       through: :favorite_books, source: :book
  has_many :favorite_reviews, dependent: :destroy
  has_many :fav_reviews,       through: :favorite_reviews, source: :review
  has_many :favorite_questions, dependent: :destroy
  has_many :fav_questions,       through: :favorite_questions, source: :question
  has_many :favorite_replies, dependent: :destroy
  has_many :fav_replies,       through: :favorite_replies, source: :reply
  has_many :favorite_subject_questions, dependent: :destroy
  has_many :fav_subject_questions,       through: :favorite_subject_questions, source: :subject_question
  has_many :favorite_subject_question_replies, dependent: :destroy
  has_many :fav_subject_question_replies,       through: :favorite_subject_question_replies, source: :subject_question_reply
  has_many :browsing_histories, dependent: :destroy
  has_many :watched_books,     through: :browsing_histories, source: :book



  validates :name,  presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 250 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :first_choice_school, length: { maximum: 30 }
  validates :second_choice_school, length: { maximum: 30 }
  validates :third_choice_school, length: { maximum: 30 }
  validates :introduction, length: { maximum: 200 }




end
