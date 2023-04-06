class User < ApplicationRecord

has_many :books
has_many :reviews




  validates :name,  presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 250 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :first_choice_school, length: { maximum: 30 }
  validates :second_choice_school, length: { maximum: 30 }
  validates :third_choice_school, length: { maximum: 30 }
  validates :introduction, length: { maximum: 200 }




end
