class CreateFavoriteSurveys < ActiveRecord::Migration[6.1]
  def change
    create_table :favorite_surveys do |t|
      t.integer :user_id
      t.integer :survey_id

      t.timestamps
    end
  end
end
