class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :action_user_id
      t.integer :target_user_id
      t.integer :review_id
      t.integer :question_id
      t.integer :reply_id
      t.integer :subect_question_id
      t.integer :subject_question_reply_id
      t.string :action_type
      t.string :action_to
      t.boolean :is_checked

      t.timestamps
    end
  end
end
