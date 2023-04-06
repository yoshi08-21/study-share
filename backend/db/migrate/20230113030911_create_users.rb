class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :uid
      t.string :first_choice_school
      t.string :second_choice_school
      t.string :third_choice_school
      t.string :introduction
      t.boolean :admin

      t.timestamps

    end
    add_index :users, :email, unique: true
  end
end
