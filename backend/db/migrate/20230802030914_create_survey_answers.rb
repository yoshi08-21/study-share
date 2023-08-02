class CreateSurveyAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_answers do |t|
      t.integer :user_id
      t.integer :survey_id
      t.integer :selected_option

      t.timestamps
    end
  end
end
