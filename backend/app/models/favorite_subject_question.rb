class FavoriteSubjectQuestion < ApplicationRecord

  belongs_to :user
  belongs_to :subject_question
end
