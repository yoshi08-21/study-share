class CreateFavoriteSubjectQuestionReplies < ActiveRecord::Migration[6.1]
  def change
    create_table :favorite_subject_question_replies do |t|
      t.integer :user_id
      t.integer :subject_question_reply_id

      t.timestamps
    end
  end
end
