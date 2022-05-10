class AddUserEmailsConfirmation < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :confirmation_link, :string, null: false
    add_column :users, :email_verified, :boolean, default: false, null: false
  end
end
