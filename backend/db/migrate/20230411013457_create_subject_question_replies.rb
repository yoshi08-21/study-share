class CreateSubjectQuestionReplies < ActiveRecord::Migration[6.1]
  def change
    create_table :subject_question_replies do |t|
      t.text :content
      t.integer :user_id
      t.integer :subject_question_id

      t.timestamps
    end
  end
end
