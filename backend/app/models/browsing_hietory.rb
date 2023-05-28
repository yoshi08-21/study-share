class BrowsingHietory < ApplicationRecord

  belongs_to :user
  belongs_to :book,   optional: true
  belongs_to :review,   optional: true
  belongs_to :question, optional: true
  belongs_to :reply,    optional: true
  belongs_to :subject_question, optional: true
  belongs_to :subject_question_reply, optional: true

  validates :user_id,   presence: true


end
