class CreateFavoriteReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :favorite_reviews do |t|
      t.integer :user_id
      t.integer :review_id

      t.timestamps
    end
  end
end
