class RenameColumnInNotifications < ActiveRecord::Migration[6.1]
  def change
    rename_column :notifications, :subect_question_id, :subject_question_id
  end
end
