class Notification < ApplicationRecord

  belongs_to :action_user, class_name: 'User', foreign_key: 'action_user_id'
  belongs_to :target_user, class_name: 'User', foreign_key: 'target_user_id'

  belongs_to :review,   optional: true
  belongs_to :question, optional: true
  belongs_to :reply,    optional: true
  belongs_to :subject_question, optional: true
  belongs_to :subject_question_reply, optional: true

end
