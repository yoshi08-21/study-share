class CreateSurveys < ActiveRecord::Migration[6.1]
  def change
    create_table :surveys do |t|
      t.string :title
      t.text :content
      t.string :option1
      t.string :option2
      t.string :option3
      t.string :option4
      t.string :image
      t.boolean :status
      t.integer :user_id

      t.timestamps
    end
  end
end
