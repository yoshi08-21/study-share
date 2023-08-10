class RemoveColumnFromSurveys < ActiveRecord::Migration[6.1]
  def change
    remove_column :surveys, :image, :string
  end
end
