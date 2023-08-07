class AddColumnToBrowsingHistories < ActiveRecord::Migration[6.1]
  def change
    add_column :browsing_histories, :survey_id, :integer
  end
end
