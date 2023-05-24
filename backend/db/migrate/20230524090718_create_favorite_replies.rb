class CreateFavoriteReplies < ActiveRecord::Migration[6.1]
  def change
    create_table :favorite_replies do |t|
      t.integer :user_id
      t.integer :reply_id

      t.timestamps
    end
  end
end
