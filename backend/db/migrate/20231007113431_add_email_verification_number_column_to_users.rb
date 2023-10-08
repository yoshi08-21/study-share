class AddEmailVerificationNumberColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :email_verification_number, :integer
  end
end
