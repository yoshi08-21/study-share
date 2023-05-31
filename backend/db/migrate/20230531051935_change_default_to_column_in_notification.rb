class ChangeDefaultToColumnInNotification < ActiveRecord::Migration[6.1]
  def change
    change_column_default :notifications, :is_checked, false
  end
end
