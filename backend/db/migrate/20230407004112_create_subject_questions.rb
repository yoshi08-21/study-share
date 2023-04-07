class CreateSubjectQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :subject_questions do |t|
      t.string :title
      t.text :content
      t.string :subject
      t.integer :user_id

      t.timestamps
    end
  end
end
