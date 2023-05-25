class CreateFavoriteSubjectQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :favorite_subject_questions do |t|
      t.integer :user_id
      t.integer :subject_question_id

      t.timestamps
    end
  end
end
