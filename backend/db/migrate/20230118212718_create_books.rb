class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :name
      t.string :author
      t.string :publisher
      t.string :subject
      t.integer :user_id

      t.timestamps
    end
  end
end
