class FavoriteSubjectQuestion < ApplicationRecord

  belongs_to :user
  belongs_to :subject_question

  validates_uniqueness_of :subject_question_id, scope: :user_id

end
