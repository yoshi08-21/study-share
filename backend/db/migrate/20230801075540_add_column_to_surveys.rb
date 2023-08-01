class AddColumnToSurveys < ActiveRecord::Migration[6.1]
  def change
    add_column :surveys, :genre, :string
  end
end
