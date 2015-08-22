class AddExpirationReason < ActiveRecord::Migration
  def change
    add_column :accounts, :expiration_reason, :text
  end
end
