class TwitterFacebookAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :type, :string
    Account.reset_column_information
    Account.update_all(:type=>"TwitterAccount")
  end

  def self.down
    remove_column :accounts, :type
  end
end
