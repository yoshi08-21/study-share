class AddColumnToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :description, :text
  end
end
