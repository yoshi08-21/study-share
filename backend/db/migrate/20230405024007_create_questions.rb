class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :title
      t.text :content
      t.string :subject
      t.integer :user_id
      t.integer :book_id

      t.timestamps
    end
  end
end
